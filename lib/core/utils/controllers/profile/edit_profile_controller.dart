import 'package:flutter/material.dart';

class EditProfileController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  void clear() {
    nameController.clear();
    emailController.clear();
    dobController.clear();
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
  }
}

final EditProfileController editProfileController = EditProfileController();
