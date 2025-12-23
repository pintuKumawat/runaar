import 'package:flutter/material.dart';

class SignUpController {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
