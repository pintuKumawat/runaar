import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_create_model.dart';
import 'package:runaar/repos/subscription/subscription_create_repo.dart';

class SubscriptionCreateProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoding = false;
  SubscriptionCreateModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoding;
  SubscriptionCreateModel? get response => _response;

  Future<void> subscriptionCreate({
    required int userId,
    required int subscriptionId,
    required int amount,
  }) async {
    _isLoding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await subscriptionCreateRepo.subscriptionCreate(
        userId: userId,
        subscriptionId: subscriptionId,
        amount: amount,
      );
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoding = false;
      notifyListeners();
    }
  }
}
