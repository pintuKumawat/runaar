import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/home/booking_request_model.dart';
import 'package:runaar/repos/home/booking_request_repo.dart';

class BookingRequestProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  BookingRequestModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  BookingRequestModel? get response => _response;

  Future<void> bookingRequest({
    required int tripId,
    required int userId,
    required int seatRequest,
    required double totalPrice,
    required String paymentMethod,
    required String paymentStatus,
    required String specialMessage,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await bookingRequestRepo.bookingRequest(
        tripId: tripId,
        userId: userId,
        seatRequest: seatRequest,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        specialMessage: specialMessage,
      );
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = "Unexpected error : ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
