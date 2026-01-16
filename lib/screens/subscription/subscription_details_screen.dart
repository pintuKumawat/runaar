
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/models/profile/account/subscription_plan_model.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final Data plan;

  const SubscriptionDetailsScreen({super.key, required this.plan});

  @override
  State<SubscriptionDetailsScreen> createState() => _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  late Razorpay _razorpay;
  @override
  void initState() {
   
    super.initState();
    
  _razorpay = Razorpay();
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


  }
  
  @override
  void dispose(){
    _razorpay.clear();
    super.dispose();
  }

   void _openCheckout() {
    var options = {
      'key': dotenv.get("RAZORPAY_KEY"), 
      'amount': (widget.plan.amount ?? 0) * 100, 
      'name': 'Runaar',
      'description': widget.plan.subscriptionType ?? 'Subscription',
      'prefill': {
        'contact': '9999999999',
        'email': 'test@runaar.com'
      },
      'theme': {
        'color': '#000000',
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  /// ✅ SUCCESS
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Success: ${response.paymentId}");

    appSnackbar.showSingleSnackbar(context, "Payment Successful ");

   
  }

  ///  FAILURE
  void _handlePaymentError(PaymentFailureResponse response) {
   appSnackbar.showSingleSnackbar(context, "Payment Failed  ${response.message}");
  }

  ///  WALLET
  void _handleExternalWallet(ExternalWalletResponse response) {
    appSnackbar.showSingleSnackbar(context, "External Wallet: ${response.walletName}");
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      bottomNavigationBar:  _payButton(),
      
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Subscription Details"),
      ),
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

 Widget _payButton(){
  return Padding(
    padding: 16.all,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith(
          (states) => appColor.backgroundColor,
        ),
      ),
      onPressed: () {
       _openCheckout();
      },
      child: Text(
        "Pay ₹${widget.plan.amount}",
        style: TextStyle(color: appColor.mainColor),
     
      ),
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
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
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
}
