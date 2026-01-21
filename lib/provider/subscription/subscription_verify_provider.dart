import 'package:flutter/foundation.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_verify_model.dart';
import 'package:runaar/repos/subscription/subscription_verify_repo.dart';

class SubscriptionVerifyProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoding = false;
  SubscriptionVerifyModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoding;
  SubscriptionVerifyModel? get response => _response;

  Future<void> subscriptionVerify({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    _isLoding = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await subscriptionVerifyRepo.subscriptionVerify(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
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
