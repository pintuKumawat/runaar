import 'package:flutter/material.dart';

class SignUpController {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void clear() {
    mobileController.clear();
    passwordController.clear();
    emailController.clear();
    nameController.clear();
  }

  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
  }
}

final SignUpController signUpController = SignUpController();
