import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/provider/profile/account/user_deactivate_provider.dart';
import 'package:runaar/screens/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountScreen extends StatefulWidget {
  final int userId;
  const DeleteAccountScreen({super.key, required this.userId});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  bool agree = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Deactivate Account"),
        centerTitle: true,
      ),
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

              _infoCard(textTheme),

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
      padding: 16.all,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.red.withOpacity(.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade600,
            size: 26.sp,
          ),
          12.width,
          Expanded(
            child: Text(
              "This action will deactivate your account access",
              style: theme.titleMedium?.copyWith(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- INFO CARD --------------------
  Widget _infoCard(TextTheme theme) {
    return Container(
      padding: 14.all,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _infoPoint("Your account will be temporarily deactivated", theme),
          _divider(),
          _infoPoint("Your profile will not be visible to other users", theme),
          _divider(),
          _infoPoint("Any active bookings will be paused", theme),
          _divider(),
          _infoPoint(
            "Your personal data will remain safe and unchanged",
            theme,
          ),
          _divider(),
          _infoPoint("You can request account restoration anytime", theme),
        ],
      ),
    );
  }

  // -------------------- INFO POINT --------------------
  Widget _infoPoint(String text, TextTheme theme) {
    return Padding(
      padding: 6.vertical,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18.sp,
            color: Colors.grey.shade600,
          ),
          10.width,
          Expanded(
            child: Text(
              text,
              style: theme.bodyMedium?.copyWith(
                color: appColor.textColor.withOpacity(.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- DIVIDER --------------------
  Widget _divider() {
    return Padding(
      padding: 6.vertical,
      child: Divider(height: 1, color: Colors.grey.shade300),
    );
  }

  // -------------------- CONFIRMATION CHECK --------------------
  Widget _confirmationCheck(TextTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: agree,
          checkColor: Colors.white,
          onChanged: (v) => setState(() => agree = v ?? false),
        ),
        6.width,
        Expanded(
          child: Text(
            "I understand that deactivating my account will restrict access and visibility.",
            style: theme.bodySmall?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }

  // -------------------- DEACTIVATE BUTTON --------------------
  Widget _deactivateButton(TextTheme theme) {
    return Consumer<UserDeactivateProvider>(
      builder: (context, provider, child) {
        return BottomAppBar(
          child: SizedBox(
            height: 40.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onPressed: () async {
                //  CHECKBOX VALIDATION
                if (!agree) {
                  appSnackbar.showSingleSnackbar(
                    context,
                    "Please confirm before deactivating your account",
                  );
                  return;
                }

                // CALL API
                await provider.userDeactivate(userId: widget.userId);

                if (provider.errorMessage != null) {
                  appSnackbar.showSingleSnackbar(
                    context,
                    provider.errorMessage ?? "",
                  );
                  return;
                }

                appSnackbar.showSingleSnackbar(
                  context,
                  provider.response?.message ??
                      "Account deactivated successfully",
                );

                await Future.delayed(const Duration(seconds: 1));

                await _logout();
              },
              child: provider.isLoading
                  ? CircularProgressIndicator()
                  : Text("Deactivate Account"),
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(savedData.userId, 0);
    prefs.setBool(savedData.isLoggedIn, false);
    prefs.remove(savedData.mob);
    prefs.remove(savedData.email);
    prefs.remove(savedData.fcmToken);
    prefs.remove(savedData.language);
    await Future.delayed(Duration(milliseconds: 300));
    appNavigator.pushAndRemoveUntil(LoginScreen());
  }
}
