import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

class DeleteAccountScreen extends StatefulWidget {
  final int userId;
  const DeleteAccountScreen({super.key, required this.userId});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordCtrl = TextEditingController();

  bool showPassword = false;
  bool agree = false;

  @override
  void dispose() {
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Deactivate Account")),
      bottomNavigationBar: _deactivateButton(textTheme),
      body: SingleChildScrollView(
        padding: 16.all,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _warningHeader(textTheme),

              20.height,

              _infoPoint(
                "Your account will be deactivated, not permanently deleted.",
                textTheme,
              ),
              _infoPoint(
                "You can reactivate your account by logging in again.",
                textTheme,
              ),
              _infoPoint(
                "Your profile and ride history will be kept safe.",
                textTheme,
              ),
              _infoPoint(
                "You will not be visible to other users while deactivated.",
                textTheme,
              ),

              30.height,

              _label("Confirm Password", textTheme),
              _passwordField(textTheme),

              20.height,

              _confirmationCheck(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- WARNING HEADER --------------------
  Widget _warningHeader(TextTheme theme) {
    return Container(
      padding: 14.all,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 26.sp),
          12.width,
          Expanded(
            child: Text(
              "This action will deactivate your account",
              style: theme.titleMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- INFO POINT --------------------
  Widget _infoPoint(String text, TextTheme theme) {
    return Padding(
      padding: 5.vertical,
      child: Row(
        crossAxisAlignment: .center,
        children: [
          Icon(Icons.circle, size: 8.sp, color: Colors.grey),
          10.width,
          Expanded(
            child: Text(
              text,
              style: theme.bodyMedium?.copyWith(
                color: appColor.textColor.withOpacity(.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- LABEL --------------------
  Widget _label(String text, TextTheme theme) {
    return Text(
      text,
      style: theme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        
      ),
    );
  }

  // -------------------- PASSWORD FIELD --------------------
  Widget _passwordField(TextTheme theme) {
    return TextFormField(
      controller: passwordCtrl,
      obscureText: !showPassword,
      style: theme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => showPassword = !showPassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return "Password is required";
        if (v.length < 6) return "Invalid password";
        return null;
      },
    );
  }

  Widget _confirmationCheck(TextTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: agree, onChanged: (v) => setState(() => agree = v!)),
        6.width,
        Expanded(
          child: Text(
            "I understand that my account will be deactivated and I can "
            "reactivate it later by logging in again.",
            style: theme.bodySmall,
          ),
        ),
      ],
    );
  }

  // -------------------- DEACTIVATE BUTTON --------------------
  Widget _deactivateButton(TextTheme theme) {
    return BottomAppBar(
      child: SizedBox(
        height: 56.h,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: _deactivateAccount,
          child: Text("Deactivate Account"),
        ),
      ),
    );
  }

  // -------------------- ACTION --------------------
  void _deactivateAccount() {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      appSnackbar.showSingleSnackbar(
        context,
        "Please confirm before proceeding",
      );
      return;
    }
    appSnackbar.showSingleSnackbar(context, "Account deactivated successfully");
  }
}
