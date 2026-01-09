import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/payment/create_payment_model.dart';
import 'package:runaar/repos/payment/create_payment_repo.dart';

class CreatePaymentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  CreatePaymentModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  CreatePaymentModel? get response => _response;

  Future<void> createPayment({
    required int userId,
    required int tripId,
    required int amount,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await createPaymentRepo.createPayment(
        userId: userId,
        tripId: tripId,
        amount: amount,
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
