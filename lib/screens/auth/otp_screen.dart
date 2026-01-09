import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/auth/forgot_password_provider.dart';
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

  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  int _secondsRemaining = 60;
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
      appBar: AppBar(title: const Text("Verify OTP"), centerTitle: true),
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
        : Consumer<ForgotPasswordProvider>(
            builder: (context, value, child) => TextButton(
              onPressed: () => _resendOtpAction(value),
              child: value.isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      "Resend OTP",
                      style: TextStyle(color: appColor.secondColor),
                    ),
            ),
          );
  }

  Widget _verifyButton() {
    return Consumer<OtpVerifyProvider>(
      builder: (BuildContext context, otpVerifyProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 40.h,
          child: ElevatedButton(
            onPressed: () => otpVerifyProvider.isLoading
                ? null
                : _verifyOtp(otpVerifyProvider),
            child: otpVerifyProvider.isLoading
                ? const CircularProgressIndicator()
                : const Text("Verify OTP"),
          ),
        );
      },
    );
  }

  void _verifyOtp(OtpVerifyProvider otpVerifyProvider) async {
    if (!_formKey.currentState!.validate()) {
      appSnackbar.showSingleSnackbar(context, "Enter complete OTP");
      return;
    }

    final otp = _otpControllers.map((e) => e.text).join();

    if (otp.length != 6) {
      appSnackbar.showSingleSnackbar(context, "Enter 6 digit OTP");
      return;
    }
    await otpVerifyProvider.otpVerify(mobNumber: widget.mobile, otp: otp);

    if (otpVerifyProvider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(
        context,
        otpVerifyProvider.errorMessage ?? "",
      );
      return;
    }
    appSnackbar.showSingleSnackbar(
      context,
      otpVerifyProvider.response?.message ?? "",
    );

    appNavigator.push(ResetPasswordScreen(mobile: widget.mobile));
    for (final controller in _otpControllers) {
      controller.clear();
    }
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _resendOtpAction(ForgotPasswordProvider provider) async {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    await provider.forgotPassword(mobile: widget.mobile);

    if (provider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(context, provider.errorMessage!);
      return;
    }

    appSnackbar.showSingleSnackbar(
      context,
      provider.response?.message ?? "OTP sent successfully",
    );
    _startTimer();
  }
}
