import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  final TextEditingController signUserController = TextEditingController();
  final TextEditingController signPhoneController = TextEditingController();
  final TextEditingController signEmailController = TextEditingController();
  final TextEditingController signPasswordController = TextEditingController();

  String? userNameError;
  String? emailError;
  String? phoneNumberError;
  String? passwordError;

  bool isLoading = false;
  bool isPasswordVisible = false;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void validateUserName(String value) {
    if (value.isEmpty) {
      userNameError = "User name is required";
    } else if (value.length < 2) {
      userNameError = "User name must have at least 2 characters";
    } else {
      userNameError = null;
    }
    notifyListeners();
  }

  void validateEmail(String value) {
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value.isEmpty) {
      emailError = "Email is required";
    } else if (!emailRegex.hasMatch(value)) {
      emailError = "Please enter a valid email";
    } else {
      emailError = null;
    }
    notifyListeners();
  }

  void validateMobileNumber(String value) {
    if (value.isEmpty) {
      phoneNumberError = "Please enter mobile number";
    } else if (value.length != 10) {
      phoneNumberError = "Please enter valid mobile number";
    } else {
      phoneNumberError = null;
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');

    if (value.isEmpty) {
      passwordError = "Please enter password";
    } else if (!passwordRegex.hasMatch(value)) {
      passwordError =
          "Password must be 8 characters";
    } else {
      passwordError = null;
    }
    notifyListeners();
  }

  bool validateAll() {
    validateUserName(signUserController.text);
    validateEmail(signEmailController.text);
    validateMobileNumber(signPhoneController.text);
    validatePassword(signPasswordController.text);

    return userNameError == null &&
        emailError == null &&
        phoneNumberError == null &&
        passwordError == null;
  }


   Future<void> signup() async {
    if (!validateAll()) return;

    isLoading = true;
    notifyListeners();

  //  await Future.delayed(const Duration(seconds: 2));

    // isLoading = false;
    // notifyListeners();

   // appSnackbar.showSingleSnackbar(context, "Login Successful");
  }

  @override
  void dispose() {
    signUserController.dispose();
    signPhoneController.dispose();
    signEmailController.dispose();
    signPasswordController.dispose();
    super.dispose();
  }
}
