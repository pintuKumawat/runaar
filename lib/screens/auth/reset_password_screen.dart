import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/auth/reset_password_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mobile;

  const ResetPasswordScreen({super.key, required this.mobile});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password"), centerTitle: true),
      body: SingleChildScrollView(
        padding: 16.all,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// 🔹 IMAGE
              Center(
                child: Image.asset(
                  "assets/images/password.png",
                  height: 160.h,
                  fit: BoxFit.contain,
                ),
              ),

              15.height,

              /// 🔹 TITLE
              Text(
                "Create New Password",
                style: theme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              6.height,

              /// 🔹 SUBTITLE
              Text(
                "Your new password must be different\n from the previous one",
                textAlign: .center,
                style: theme.titleSmall?.copyWith(color: Colors.grey),
              ),

              10.height,

              _passwordField(),

              10.height,

              _confirmPasswordField(),

              15.height,

              _resetButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: !showPassword,

      // decoration: _inputDecoration(
      //   hint: "New Password",
      //   icon: Icons.lock,
      // suffix: IconButton(
      //   icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
      //   onPressed: () => setState(() => showPassword = !showPassword),
      // ),
      // ),
      decoration: InputDecoration(
        hintText: "New Password",
        prefixIcon: Icon(Icons.lock),
        suffix: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !showConfirmPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      // decoration: _inputDecoration(
      //   hint: "Confirm Password",
      //   icon: Icons.lock_outline,
      //   suffix: IconButton(
      //     icon: Icon(
      //       showConfirmPassword ? Icons.visibility_off : Icons.visibility,
      //     ),
      //     onPressed: () =>
      //         setState(() => showConfirmPassword = !showConfirmPassword),
      //   ),
      // ),
      decoration: InputDecoration(
        hintText: "Confirm Password",
        prefixIcon: Icon(Icons.lock),

        suffixIcon: IconButton(
          icon: Icon(
            showConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => showConfirmPassword = !showConfirmPassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Confirm password is required";
        }
        if (value != passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  // Widget _confirmPasswordField(ThemeData theme) {
  //   return TextFormField(
  //     controller: confirmPasswordController,
  //     obscureText: !showConfirmPassword,
  //     decoration: InputDecoration(
  //       hintText: "Confirm Password",
  //       prefixIcon: const Icon(Icons.lock_outline),
  //     ),
  //     autovalidateMode: .onUserInteraction,
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return "Confirm password is required";
  //       }
  //       if (value != passwordController.text) {
  //         return "Passwords do not match";
  //       }
  //       return null;
  //     },
  //   );
  // }

  // -------------------- RESET BUTTON --------------------
  Widget _resetButton() {
    return Consumer<ResetPasswordProvider>(
      builder: (context, resetPasswordProvider, child) => SizedBox(
        width: double.infinity,
        height: 40.h,
        child: ElevatedButton(
          onPressed: () => resetPasswordProvider.isLoading
              ? null
              : _resetPassword(resetPasswordProvider),
          child: resetPasswordProvider.isLoading
              ? const CircularProgressIndicator()
              : const Text("Reset Password"),
        ),
      ),
    );
  }

  void _resetPassword(ResetPasswordProvider resetPasswordProvider) async {
    if (!_formKey.currentState!.validate()) return;

    await resetPasswordProvider.resetPassword(
      mobNumber: widget.mobile,
      password: passwordController.text,
    );

    if (resetPasswordProvider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(
        context,
        resetPasswordProvider.errorMessage ?? "",
      );
      return;
    }

    appSnackbar.showSingleSnackbar(context, "Password reset successfully");

    appNavigator.pushAndRemoveUntil(LoginScreen());
  }
}
