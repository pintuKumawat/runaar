import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/privacyPolicy/privacy_policy_model.dart';
import 'package:runaar/repos/privacyPolicy/privacy_policy_repo.dart';

class PrivacyPolicyProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading=false;
  PrivacyPolicyModel? _response;

  String? get errorMessage=>_errorMessage;
  bool get isLoading=>_isLoading;
  PrivacyPolicyModel? get response=>_response;

   Future<void> getSubscriptions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await privacyPolicyRepo.privacyPolicy();
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
}