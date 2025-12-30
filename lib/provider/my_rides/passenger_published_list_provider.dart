import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/passenger_published_list_model.dart';
import 'package:runaar/repos/my_rides/passenger_published_list_repo.dart';

class PassengerPublishedListProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  PassengerPublishedListModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PassengerPublishedListModel? get response => _response;

  Future<void> passengerList({required int tripId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await passengerPublishedListRepo.passengerList(
        tripId: tripId,
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
