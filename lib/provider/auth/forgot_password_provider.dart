import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/auth/forgot_password_model.dart';
import 'package:runaar/repos/auth/forgot_password_repo.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  ForgotPasswordModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  ForgotPasswordModel? get response => _response;

  Future<void> forgotPassword({required String mobile}) async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();
    try {
      final result = await forgotPasswordRepo.forgotPassword(
        mobileNumber: mobile,
      );

      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("❌ API Exception: $e");
    } catch (e) {
      _errorMessage = "Unexpected error: ${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
