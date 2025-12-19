import 'package:flutter/material.dart';

class LoginController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void clear() {
    mobileController.clear();
    passwordController.clear();
  }

  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
  }
}

final LoginController loginController = LoginController();
