import 'package:flutter/foundation.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_plan_model.dart';
import 'package:runaar/repos/subscription/subscription_plan_repo.dart';


class SubscriptionProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  SubscriptionPlanModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  SubscriptionPlanModel? get response => _response;

  Future<void> getSubscriptions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await subscriptionRepo.getSubscriptions();
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
