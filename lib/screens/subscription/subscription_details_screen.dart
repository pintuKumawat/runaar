import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/models/subscription/subscription_plan_model.dart';
import 'package:runaar/provider/subscription/subscription_create_provider.dart';
import 'package:runaar/provider/subscription/subscription_status_provider.dart';
import 'package:runaar/provider/subscription/subscription_verify_provider.dart';
import 'package:runaar/screens/home/bottom_nav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final Data plan;
  final int userId;

  const SubscriptionDetailsScreen({
    super.key,
    required this.plan,
    required this.userId,
  });

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  String mobileNumber = "";
  String email = "";

  bool _isVerifyingDialogOpen = false;
  late Razorpay _razorpay;
  String razorPayOrderId = "";
  @override
  void initState() {
    super.initState();
    fetchUserData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        mobileNumber = prefs.getString(savedData.mob) ?? "";
        email = prefs.getString(savedData.email) ?? "";
      });
    }
  }

  void _openCheckout() {
    var options = {
      'key': dotenv.get("RAZORPAY_KEY"),
      'amount': (widget.plan.amount ?? 0) * 100,
      'name': 'Runaar',
      'description': widget.plan.subscriptionType ?? 'Subscription',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'order_id': razorPayOrderId,
      'prefill': {'contact': '9079799241', 'email': email},
      'theme': {'color': '#000000'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  /// ✅ SUCCESS
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _showVerifyingDialog();
    final provider = context.read<SubscriptionVerifyProvider>();
    await provider.subscriptionVerify(
      razorpayOrderId: response.orderId ?? "",
      razorpayPaymentId: response.paymentId ?? "0",
      razorpaySignature: response.signature ?? "",
    );
    if (provider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(context, provider.errorMessage ?? "");
      return;
    }

    await _waitForPaymentConfirmation();
  }

  ///  FAILURE
  void _handlePaymentError(PaymentFailureResponse response) {
    appSnackbar.showSingleSnackbar(
      context,
      "Payment Failed  ${response.message}",
    );
  }

  ///  WALLET
  void _handleExternalWallet(ExternalWalletResponse response) {
    appSnackbar.showSingleSnackbar(
      context,
      "External Wallet: ${response.walletName}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      bottomNavigationBar: _payButton(),

      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Subscription Details")),
      body: SingleChildScrollView(
        padding: 16.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 PLAN CARD
            _planCard(theme),

            24.height,

            /// 📌 DETAILS
            Text(
              "Plan Benefits",
              style: theme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            14.height,

            _detailTile(
              icon: Icons.calendar_today,
              title: "Duration",
              value: "${widget.plan.duration ?? 0} Days",
            ),

            _detailTile(
              icon: Icons.directions_car,
              title: "Total Rides",
              value: "${widget.plan.totalRides ?? 0}",
            ),

            _detailTile(
              icon: Icons.currency_rupee,
              title: "Subscription Amount",
              value: "₹${widget.plan.amount ?? 0}",
            ),

            _detailTile(
              icon: Icons.description,
              title: "Description",
              value: widget.plan.subscriptionDescription ?? "-",
            ),

            32.height,

            /// 🚀 CONTINUE BUTTON
          ],
        ),
      ),
    );
  }

  Widget _payButton() {
    return Padding(
      padding: 16.all,
      child: Consumer<SubscriptionCreateProvider>(
        builder: (BuildContext context, provider, child) {
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateColor.resolveWith(
                (states) => appColor.backgroundColor,
              ),
            ),
            onPressed: () async {
              await provider.subscriptionCreate(
                userId: widget.userId,
                subscriptionId: widget.plan.subscriptionId ?? 0,
                amount: widget.plan.amount ?? 0,
              );
              if (provider.errorMessage != null) {
                return appSnackbar.showSingleSnackbar(
                  context,
                  provider.errorMessage ?? "",
                );
              }
              razorPayOrderId = provider.response?.orderId ?? "";
              _openCheckout();
            },
            child: Text(
              "Pay ₹${widget.plan.amount}",
              style: TextStyle(color: appColor.mainColor),
            ),
          );
        },
      ),
    );
  }

  /// 🔥 PLAN CARD (REUSED STYLE)
  Widget _planCard(TextTheme theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appColor.subscriptionCardColor1,
            appColor.subscriptionCardColor2,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(18.w),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              Text(
                widget.plan.subscriptionType ?? "",
                style: theme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              8.height,

              /// DESCRIPTION
              Text(
                widget.plan.subscriptionDescription ?? "",
                style: theme.bodyMedium?.copyWith(
                  color: Colors.grey.shade300,
                  height: 1.4,
                ),
              ),

              //  18.height,

              /// PRICE
            ],
          ),
          Text(
            "₹${widget.plan.amount ?? 0}",
            style: theme.titleLarge?.copyWith(
              color: appColor.buttonColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  /// 📄 DETAIL TILE
  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20.sp),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                4.height,
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _waitForPaymentConfirmation() async {
    final subscriptionPaymentStatus = context
        .read<SubscriptionStatusProvider>();

    Timer.periodic(Duration(seconds: 5), (timer) async {
      await subscriptionPaymentStatus.SubscriptionStatus(
        razorpayOrderId: razorPayOrderId,
        userId: widget.userId,
      );

      if (!mounted) return;

      if (subscriptionPaymentStatus.errorMessage != null) {
        appSnackbar.showSingleSnackbar(
          context,
          subscriptionPaymentStatus.errorMessage!,
        );
        return;
      }

      final status = subscriptionPaymentStatus.response?.data;
      debugPrint("status: $status");
      if (status == 'captured') {
        timer.cancel();
        _closeVerifyingDialog();
        appSnackbar.showSingleSnackbar(
          context,
          subscriptionPaymentStatus.response?.message ?? "",
        );
        appNavigator.pushAndRemoveUntil(BottomNav(initialIndex: 2));
        return;
      } else if (status == 'failed') {
        timer.cancel();
        _closeVerifyingDialog();
        return appSnackbar.showSingleSnackbar(context, "Payment failed");
      }
    });
  }

  void _showVerifyingDialog() {
    if (_isVerifyingDialogOpen) return;

    _isVerifyingDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Verifying payment, please wait...",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _closeVerifyingDialog() {
    if (!_isVerifyingDialogOpen || !mounted) return;

    _isVerifyingDialogOpen = false;
    appNavigator.pop();
  }
}
