import 'package:flutter/foundation.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_status_model.dart';
import 'package:runaar/repos/subscription/subscription_status_repo.dart';


class SubscriptionStatusProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isloading = false;
  SubscriptionStatusModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isloading;
  SubscriptionStatusModel? get response => _response;

  Future<void> SubscriptionStatus({
    required String razorpayOrderId,
    required int userId,
  }) async {
    _isloading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await subscriptionStatusRepo.subscriptionStatus(
        razorpayOrderId: razorpayOrderId,
        userid: userId,
      );
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
