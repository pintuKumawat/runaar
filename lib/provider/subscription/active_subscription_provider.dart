import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/active_subscription_model.dart';
import 'package:runaar/repos/subscription/active_subscription_repo.dart';

class ActiveSubscriptionProvider extends ChangeNotifier {

  String? _errorMessage;
  bool _isLoading=false;

  ActiveSubscriptionModel?_response;
   Message? activeSubscription;


  String? get errorMessage=>_errorMessage;
  bool get isLoading=>_isLoading;
  ActiveSubscriptionModel? get response=>_response;

  Future<void>ActiveSubscription({required int userId})async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await activeSubscriptionRepo.activeSubscription(
        userId: userId,
        
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