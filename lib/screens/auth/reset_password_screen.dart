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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: 16.all,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: .min,
              children: [
                _title(theme),
                10.height,
                _subtitle(theme),
                30.height,
                _passwordField(theme),
                15.height,
                _confirmPasswordField(theme),
                30.height,
                _resetButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title(ThemeData theme) {
    return Text(
      "Create New Password",
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _subtitle(ThemeData theme) {
    return Text(
      "Your new password must be different from the previous one",
      style: theme.textTheme.titleSmall,
      textAlign: TextAlign.center,
    );
  }

  Widget _passwordField(ThemeData theme) {
    return TextFormField(
      controller: passwordController,
      obscureText: !showPassword,
      decoration: InputDecoration(
        hintText: "New Password",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
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

  Widget _confirmPasswordField(ThemeData theme) {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: !showConfirmPassword,
      decoration: InputDecoration(
        hintText: "Confirm Password",
        prefixIcon: const Icon(Icons.lock_outline),
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

  // -------------------- RESET BUTTON --------------------
  Widget _resetButton() {
    return Consumer<ResetPasswordProvider>(
      builder: (context, resetPasswordProvider, child) => SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: () =>
              resetPasswordProvider.isLoading ? null : _resetPassword,
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
