import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/home/ride_search_model.dart';
import 'package:runaar/repos/home/ride_search_repo.dart';

class HomeProvider extends ChangeNotifier {
  int _seats = 1;
  int get seats => _seats;

  bool _isLoading = false;
  String? _errorMessage;
  RideSearchModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RideSearchModel? get response => _response;

  void increment() {
    if (_seats < 7) {
      _seats++;

      notifyListeners();
    }
  }

  void decrement() {
    if (_seats > 1) {
      _seats--;
      notifyListeners();
    }
  }

  Future<void> rideSearch({
    required String deptDate,
    required String originCity,
    required String destinationCity,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await rideSearchRepo.rideSearch(
        deptDate: deptDate,
        originCity: originCity,
        destinationCity: destinationCity,
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
