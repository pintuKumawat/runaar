import 'package:flutter/material.dart';

class SignUpController {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  void clear() {
    mobileController.clear();
    passwordController.clear();
    emailController.clear();
    nameController.clear();
    dobController.clear();
    genderController.clear();
  }

  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    emailController.dispose();
    nameController.dispose();
    dobController.dispose();
    genderController.dispose();
  }
}

final SignUpController signUpController = SignUpController();
