import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/booking_list_model.dart';
import 'package:runaar/repos/my_rides/booking_list_repo.dart';

class BookingListProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  BookingListModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  BookingListModel? get response => _response;

  Future<void> bookingList({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await bookingListRepo.bookingList(userId: userId);
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
