import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/payment/verify_payment_model.dart';
import 'package:runaar/repos/payment/verify_payment_repo.dart';

class VerifyPaymentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  VerifyPaymentModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  VerifyPaymentModel? get response => _response;

  Future<void> verifyPayment({
    required String razorpayOrderId,
    required String razorpaySignature,
    required String razorpayPaymentId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await verifyPaymentRepo.verifyPayment(
        razorpayOrderId: razorpayOrderId,
        razorpaySignature: razorpaySignature,
        razorpayPaymentId: razorpayPaymentId,
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
