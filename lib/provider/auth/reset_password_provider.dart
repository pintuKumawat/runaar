import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/account/reset_password_model.dart';
import 'package:runaar/repos/auth/reset_password_repo.dart';

class ResetPasswordProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  ResetPasswordModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  ResetPasswordModel? get response => _response;

  Future<void> resetPassword({
    required String mobNumber,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await resetPasswordRepo.resetPassword(
        mobNumber: mobNumber,
        password: password,
      );
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
