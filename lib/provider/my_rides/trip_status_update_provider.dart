import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/trip_status_update_model.dart';
import 'package:runaar/repos/my_rides/trip_status_update_repo.dart';

class TripStatusUpdateProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  TripStatusUpdateModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TripStatusUpdateModel? get response => _response;

  Future<void> tripStatus({
    required int tripId,
    required String status,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await tripStatusUpdateRepo.statusUpdate(
        tripId: tripId,
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
