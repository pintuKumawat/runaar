import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/profile/change_password_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/profile/account/change_password_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  final int userId;
  const ChangePasswordScreen({super.key, required this.userId});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        elevation: 0,
      ),
      // bottomNavigationBar: _saveButton(textTheme),
      body: Center(
        child: SingleChildScrollView(
          padding: 10.horizontal,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// IMAGE
                Image.asset("assets/images/change.png", height: 140.h),

                18.height,

                /// FORM CARD
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Secure Your Account",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    20.height,

                    _labelText(label: "Current Password", textTheme: textTheme),
                    _passwordField(textTheme),

                    16.height,

                    _labelText(label: "New Password", textTheme: textTheme),
                    _confirmPasswordField(textTheme),
                    20.height,
                    _saveButton(textTheme),
                  ],
                ),
              ],
            ),
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
      controller: changePasswordController.currentController,
      obscureText: !showPassword,
      style: textTheme.bodyMedium,
      // decoration: UnderlineInputBorder(
      //   // hint
      //   // : "Enter current password",
      // ),
      decoration: InputDecoration(
        contentPadding: 14.horizontal,
        prefixIcon: Icon(Icons.lock),
        hintText: "Enter current password",
        suffix: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return "Current Password is required";
        }
        return null;
      },
    );
  }

  // -------------------- CONFIRM PASSWORD --------------------
  Widget _confirmPasswordField(TextTheme textTheme) {
    return TextFormField(
      controller: changePasswordController.passwordController,
      obscureText: !showConfirmPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        hintText: "Enter New password",
        contentPadding: 14.horizontal,
        suffix: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () =>
              setState(() => showConfirmPassword = !showConfirmPassword),
        ),
      ),
      validator: (value) {
        final upper = RegExp(r'[A-Z]');
        final lower = RegExp(r'[a-z]');
        final number = RegExp(r'[0-9]');
        final symbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
        final length = RegExp(r'.{8,}');

        if (value == null || value.isEmpty) {
          return "Please enter password";
        } else if (!length.hasMatch(value)) {
          return "Minimum 8 characters";
        } else if (!upper.hasMatch(value)) {
          return "One uppercase required";
        } else if (!lower.hasMatch(value)) {
          return "One lowercase required";
        } else if (!number.hasMatch(value)) {
          return "One number required";
        } else if (!symbol.hasMatch(value)) {
          return "One symbol required";
        }
        return null;
      },
    );
  }

  // Widget _passwordRule(String text, bool condition) {
  //   return Padding(
  //     padding: EdgeInsets.only(bottom: 6.h),
  //     child: Row(
  //       children: [
  //         Icon(
  //           condition ? Icons.check_circle : Icons.cancel,
  //           color: condition ? Colors.green.shade800 : Colors.red.shade800,
  //           // color: condition ? Colors.green.shade600 : Colors.red,
  //           size: 18.sp,
  //         ),
  //         8.width,
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               fontSize: 15.sp,
  //               color: condition ? Colors.green.shade800 : Colors.red.shade800,
  //               // color: condition ? Colors.green : Colors.red,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _saveButton(TextTheme textTheme) {
    return Consumer<ChangePasswordProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          height: 48.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              await provider.resetPassword(
                userId: widget.userId,
                password: changePasswordController.currentController.text,
                newPassword: changePasswordController.passwordController.text,
              );

              if (provider.errorMessage != null) {
                appSnackbar.showSingleSnackbar(
                  context,
                  provider.errorMessage ?? "",
                );
                return;
              }

              appSnackbar.showSingleSnackbar(
                context,
                provider.response?.message ?? "",
              );

              appNavigator.pop();
            },
            child: Text(
              "Update Password",
              style: textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  // InputDecoration _inputDecoration({
  //   required String hint,
  //   required Widget suffix,
  // }) {
  //   return InputDecoration(
  //     hintText: hint,
  //     filled: true,
  //     fillColor: Colors.grey.shade100,
  //     prefixIcon: const Icon(Icons.lock_outline),
  //     suffixIcon: suffix,
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  //     // border: OutlineInputBorder(
  //     //   borderRadius: BorderRadius.circular(14),
  //     //   borderSide: BorderSide.none,
  //     // ),
  //   );
  // }
}
