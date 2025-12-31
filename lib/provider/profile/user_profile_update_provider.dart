import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/core/utils/controllers/profile/edit_profile_controller.dart';
import 'package:runaar/models/profile/user_profile_update_model.dart';
import 'package:runaar/repos/offer/trip_publish_repo.dart';
import 'package:runaar/repos/profile/user_profile_update_repo.dart';

class UserProfileUpdateProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  String? userNameError;
  String? emailError;

  UserProfileUpdateModel? _response;

  String? get messageError => _errorMessage;

  bool get isLoading => _isLoading;

  UserProfileUpdateModel? get response => _response;


//User Validation


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

  bool validateAll(){
    validateUserName(editProfileController.nameController.text);
    validateEmail(editProfileController.emailController.text);

    return userNameError==null&&emailError==null;
  }

  Future<void> userProfileUpdate({
    required int userId,
    required String dob,
    required String gender,
    required File? profileImage,
    required String name,
    required String email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await userProfileUpdateRepo.updateProfile(
        userId: userId,
        dob: dob,
        gender: gender,
        profileImage: profileImage,
        name: name,
        email: email,
      );

      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      debugPrint("❌ API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error: ${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
