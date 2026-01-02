import 'package:flutter/material.dart';

class ChangePasswordController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController currentController = TextEditingController();

  void clear() {
    passwordController.clear();
    currentController.clear();
  }

  void dispose() {
    passwordController.dispose();
    currentController.dispose();
  }
}

final ChangePasswordController changePasswordController =
    ChangePasswordController();
