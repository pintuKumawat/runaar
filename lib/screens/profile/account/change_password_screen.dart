import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userId;
  const ChangePasswordScreen({super.key, required this.userId});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  // Password rules
  bool has8Chars = false;
  bool hasUpper = false;
  bool hasLower = false;
  bool hasNumber = false;
  bool hasSpecial = false;

  @override
  void dispose() {
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _validatePassword(String value) {
    setState(() {
      has8Chars = value.length >= 8;
      hasUpper = value.contains(RegExp(r'[A-Z]'));
      hasLower = value.contains(RegExp(r'[a-z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));
      hasSpecial = value.contains(RegExp(r'[!@#\$&*~%^()_+=|<>?{}\-]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      bottomNavigationBar: _saveButton(textTheme),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              _labelText(label: "New Password", textTheme: textTheme),
              _passwordField(textTheme),
              16.height,
              _labelText(label: "Confirm Password", textTheme: textTheme),
              _confirmPasswordField(textTheme),
              20.height,

              // PASSWORD RULES
              _passwordRule("At least 8 characters", has8Chars),
              _passwordRule("Contains uppercase letter (A-Z)", hasUpper),
              _passwordRule("Contains lowercase letter (a-z)", hasLower),
              _passwordRule("Contains number (0-9)", hasNumber),
              _passwordRule(
                "Contains special character (!@#\$%^&*)",
                hasSpecial,
              ),

              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelText({required String label, required TextTheme textTheme}) {
    return Padding(
      padding: 10.horizontal,
      child: Text(
        label,
        style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
        textAlign: .left,
      ),
    );
  }

  // -------------------- PASSWORD --------------------
  Widget _passwordField(TextTheme textTheme) {
    return TextFormField(
      controller: passwordCtrl,
      obscureText: !showPassword,
      onChanged: _validatePassword,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        // labelText: ,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return "Password is required";
        }
        if (!(has8Chars && hasUpper && hasLower && hasNumber && hasSpecial)) {
          return "Password does not meet requirements";
        }
        return null;
      },
    );
  }

  // -------------------- CONFIRM PASSWORD --------------------
  Widget _confirmPasswordField(TextTheme textTheme) {
    return TextFormField(
      controller: confirmPasswordCtrl,
      obscureText: !showConfirmPassword,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        // labelText: "Confirm Password",
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            showConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => showConfirmPassword = !showConfirmPassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return "Confirm your password";
        }
        if (v != passwordCtrl.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  // -------------------- PASSWORD RULE ROW --------------------
  Widget _passwordRule(String text, bool condition) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            condition ? Icons.check_circle : Icons.cancel,
            color: condition ? Colors.green.shade600 : Colors.red,
            size: 18.sp,
          ),
          8.width,
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                color: condition ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- SAVE BUTTON --------------------
  Widget _saveButton(TextTheme textTheme) {
    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: _changePassword,
          child: Text("Update Password"),
        ),
      ),
    );
  }

  void _changePassword() {
    if (!_formKey.currentState!.validate()) return;

    appSnackbar.showSingleSnackbar(context, "Password updated successfully");
  }
}
