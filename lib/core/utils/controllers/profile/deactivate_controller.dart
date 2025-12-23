import 'package:flutter/material.dart';

class DeactivateController {
  TextEditingController passwordController = TextEditingController();

  void clear() {
    passwordController.clear();
  }

  void dispose() {
    passwordController.dispose();
  }
}
