import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/Auth/forgot_password_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/auth/forgot_password_provider.dart';
import 'package:runaar/screens/auth/otp_screen.dart';

class ForgotMobileScreen extends StatefulWidget {
  // final int userId;
  const ForgotMobileScreen({super.key});

  @override
  State<ForgotMobileScreen> createState() => _ForgotMobileScreenState();
}

class _ForgotMobileScreenState extends State<ForgotMobileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
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
                _mobileField(),
                25.height,
                _submitButton(),
                15.height,
                _backToLogin(),
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
      "Reset Password",
      style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  // -------------------- SUBTITLE --------------------
  Widget _subtitle(TextTheme theme) {
    return Text(
      "Enter your registered mobile number",
      style: theme.titleSmall,
      textAlign: TextAlign.center,
    );
  }

  // -------------------- MOBILE FIELD --------------------
  Widget _mobileField() {
    return TextFormField(
      controller: forgotPasswordController.forgotMobileController,
      keyboardType: TextInputType.phone,
      maxLength: 10,
      decoration: const InputDecoration(
        hintText: "Enter mobile number",
        prefixIcon: Icon(Icons.phone),
        counterText: "",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Mobile number is required";
        }
        if (value.length != 10) {
          return "Enter valid 10-digit mobile number";
        }
        return null;
      },
    );
  }

  Widget _submitButton() {
    return Consumer<ForgotPasswordProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: provider.isLoading
                ? null
                : () async {
                    if (!_formKey.currentState!.validate()) return;

                    await provider.forgotPassword(
                      mobile:
                          forgotPasswordController.forgotMobileController.text,
                    );

                    if (provider.errorMessage != null) {
                      appSnackbar.showSingleSnackbar(
                        context,
                        provider.errorMessage!,
                      );
                      return;
                    }

                    appSnackbar.showSingleSnackbar(
                      context,
                      provider.response?.message ?? "OTP sent successfully",
                    );

                    appNavigator.push(
                      OtpScreen(
                        mobile: forgotPasswordController
                            .forgotMobileController
                            .text,
                      ),
                    );
                  },
            child: provider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Get OTP"),
          ),
        );
      },
    );
  }

  // -------------------- BACK TO LOGIN --------------------
  Widget _backToLogin() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Back to Login",
        style: TextStyle(color: appColor.secondColor),
      ),
    );
  }
}
