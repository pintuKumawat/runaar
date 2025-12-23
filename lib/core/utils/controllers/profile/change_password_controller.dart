import 'package:flutter/material.dart';

class ChangePasswordController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  void clear() {
    passwordController.clear();
    rePasswordController.clear();
  }

  void dispose() {
    passwordController.dispose();
    rePasswordController.dispose();
  }
}

final ChangePasswordController changePasswordController =
    ChangePasswordController();
