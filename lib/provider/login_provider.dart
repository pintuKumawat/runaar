import 'package:flutter/material.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController loginPhoneController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  String? phoneError;
  String? passwordError;
  bool isLoading = false;

    ///  Password visibility
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  /// 📱 Live Phone Validation
  void validatePhone(String value) {
    if (value.isEmpty) {
      phoneError = "Phone number is required";
    } else if (value.length != 10) {
      phoneError = "Enter valid phone number";
    } else {
      phoneError = null;
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');

    if (value.isEmpty) {
      passwordError = "Password is required";
    } else if (!passwordRegex.hasMatch(value)) {
      passwordError =
          "Password must be at least 8 character";
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  bool validateAll() {
    validatePhone(loginPhoneController.text);
    validatePassword(loginPasswordController.text);
    return phoneError == null && passwordError == null;
  }

  Future<void> login() async {
    if (!validateAll()) return;

    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    notifyListeners();

   // appSnackbar.showSingleSnackbar(context, "Login Successful");
  }

  @override
  void dispose() {
    loginPhoneController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }
}
