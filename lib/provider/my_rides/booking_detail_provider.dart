import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/booking_detail_model.dart';
import 'package:runaar/repos/my_rides/booking_detail_repo.dart';

class BookingDetailProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  BookingDetailModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BookingDetailModel? get response => _response;

  Future<void> bookingDetail({required int tripId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await bookingDetailRepo.bookingDetail(tripId: tripId);
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
