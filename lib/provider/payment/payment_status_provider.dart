import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/payment/payment_status_model.dart';
import 'package:runaar/repos/payment/payment_status_repo.dart';

class PaymentStatusProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  PaymentStatusModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaymentStatusModel? get response => _response;

  Future<void> paymentStatus({required int tripId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await paymentStatusRepo.paymentStatus(tripId: tripId);
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
