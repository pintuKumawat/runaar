import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/auth/otp_verify_provider.dart';
import 'package:runaar/screens/auth/reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobile;

  const OtpScreen({super.key, required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  bool isLoading = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: 16.all,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _title(theme),
                10.height,
                _subtitle(theme),
                25.height,
                _otpBoxes(),
                20.height,
                _resendOtp(),
                25.height,
                _verifyButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- TITLE --------------------
  Widget _title(TextTheme theme) {
    return Text(
      "OTP Verification",
      style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _subtitle(TextTheme theme) {
    return Text(
      "Enter the OTP sent to +91 ${widget.mobile}",
      style: theme.titleSmall,
      textAlign: TextAlign.center,
    );
  }

  Widget _otpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
        (index) => SizedBox(
          width: 45.w,
          child: TextFormField(
            controller: _otpControllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(counterText: ""),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  // -------------------- RESEND OTP --------------------
  Widget _resendOtp() {
    return _secondsRemaining > 0
        ? Text(
            "Resend OTP in $_secondsRemaining sec",
            style: TextStyle(color: Colors.redAccent),
          )
        : TextButton(
            onPressed: _resendOtpAction,
            child: Text(
              "Resend OTP",
              style: TextStyle(color: appColor.secondColor),
            ),
          );
  }

  // -------------------- VERIFY BUTTON --------------------
  Widget _verifyButton() {
    return Consumer<OtpVerifyProvider>(
      builder: (BuildContext context, otpVerifyProvider,child) {  
      return SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: isLoading ? null : _verifyOtp,
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Verify OTP"),
        ),
      );
      }
    );
  }

  // -------------------- VERIFY OTP ACTION --------------------
  void _verifyOtp() async {
    final provider = context.read<OtpVerifyProvider>();
    if (!_formKey.currentState!.validate()) {
      appSnackbar.showSingleSnackbar(context, "Enter complete OTP");
      return;
    }

    final otp = _otpControllers.map((e) => e.text).join();

    if (otp.length != 6) {
      appSnackbar.showSingleSnackbar(context, "Invalid OTP");
      return;
    }

    setState(() => isLoading = true);

    // 🔄 API CALL HERE
    await Future.delayed(const Duration(seconds: 1));

    setState(() => isLoading = false);

    appSnackbar.showSingleSnackbar(context, "OTP verified successfully");

    // 👉 Navigate to Reset Password
     appNavigator.push(ResetPasswordScreen(mobile: widget.mobile));
  }

  // -------------------- TIMER --------------------
  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  // -------------------- RESEND OTP ACTION --------------------
  void _resendOtpAction() {
    appSnackbar.showSingleSnackbar(context, "OTP resent successfully");
    _startTimer();

    // 🔄 Resend OTP API CALL HERE
  }
}
