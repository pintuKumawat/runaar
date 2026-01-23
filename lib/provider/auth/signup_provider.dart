import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/core/utils/controllers/auth/sign_up_controller.dart';
import 'package:runaar/models/auth/sign_up_model.dart';
import 'package:runaar/repos/auth/sign_up_repo.dart';

class SignupProvider extends ChangeNotifier {
  String? userNameError;
  String? emailError;
  String? phoneNumberError;
  String? passwordError;

  bool isLoading = false;
  bool isPasswordVisible = false;

  SignUpModel? response;
  String? errorMessage;

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
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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
    final upperCaseRegex = RegExp(r'[A-Z]');
    final lowerCaseRegex = RegExp(r'[a-z]');
    final numberRegex = RegExp(r'[0-9]');
    final symbolRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final minLengthRegex = RegExp(r'.{8,}');

    if (value.isEmpty) {
      passwordError = "Please enter password";
    } else if (!minLengthRegex.hasMatch(value)) {
      passwordError = "Password must be at least 8 characters long";
    } else if (!upperCaseRegex.hasMatch(value)) {
      passwordError = "Password must contain at least one uppercase letter";
    } else if (!lowerCaseRegex.hasMatch(value)) {
      passwordError = "Password must contain at least one lowercase letter";
    } else if (!numberRegex.hasMatch(value)) {
      passwordError = "Password must contain at least one number";
    } else if (!symbolRegex.hasMatch(value)) {
      passwordError = "Password must contain at least one special character";
    } else {
      passwordError = null;
    }

    notifyListeners();
  }

  bool validateAll() {
    validateUserName(signUpController.nameController.text);
    validateEmail(signUpController.emailController.text);
    validateMobileNumber(signUpController.mobileController.text);
    validatePassword(signUpController.passwordController.text);

    return userNameError == null &&
        emailError == null &&
        phoneNumberError == null &&
        passwordError == null;
  }

  Future<void> signup({
    required String name,
    required String email,
    required String number,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await signUpRepo.signUp(
        name: name,
        email: email,
        number: number,
        password: password,
      );
      response = result;
      // }
    } on ApiException catch (e) {
      errorMessage = e.message;
      debugPrint("❌ API Exception: $e");
    } catch (e) {
      debugPrint("❌ Unexpected error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
