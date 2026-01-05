import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/request_response_model.dart';
import 'package:runaar/repos/my_rides/request_response_repo.dart';

class RequestResponseProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  RequestResponseModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RequestResponseModel? get response => _response;

  Future<void> requestResponse({
    required int bookingId,
    required String status,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await requestResponseRepo.requestResponse(
        bookingId: bookingId,
        status: status,
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
