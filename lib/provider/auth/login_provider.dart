import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/core/utils/controllers/auth/login_controller.dart';
import 'package:runaar/models/auth/login_model.dart';
import 'package:runaar/repos/auth/login_repo.dart';

class LoginProvider extends ChangeNotifier {
  String? phoneError;
  String? passwordError;
  bool isLoading = false;
  bool isPasswordVisible = false;

  LoginModel? _response;
  String? _errorMessage;

  LoginModel? get response => _response;
  String? get errorMessage => _errorMessage;
  // for fatch userId
  int? get userId => _response?.userId;

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
    validatePhone(loginController.mobileController.text);
    validatePassword(loginController.passwordController.text);
    return phoneError == null && passwordError == null;
  }

  Future<void> login({
    required String number,
    required String password,
    required String token,
  }) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await loginRepo.login(
        number: number,
        password: password,
        token: token,
      );
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("❌ API Exception: $e");
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Unexpected error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

//
