import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/core/utils/helpers/offer_ride/load_offer_data.dart';
import 'package:runaar/models/offer/trip_publish_model.dart';
import 'package:runaar/repos/offer/trip_publish_repo.dart';

class OfferProvider extends ChangeNotifier {
  int _seats = 1;
  int get seats => _seats;

  LoadOfferData? data;

  bool _isLoading = false;
  String? _errorMessage;
  TripPublishModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  TripPublishModel? get reponse => _response;

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

  void resetSeat() {
    _seats = 1;
    notifyListeners();
  }

  Future<void> tripPublish({
    required int userId,
    required String originLat,
    required String originLong,
    required String originAddress,
    required String originCity,
    required String destinationLat,
    required String destinationLong,
    required String destinationAddress,
    required String destinationCity,
    required String deptDate,
    required String arrivalDate,
    required String deptTime,
    required String arrivalTime,
    required int vehicleId,
    required String price,
    required int availableSeats,
    required int luggageAllowed,
    required int petAllowed,
    required int smokingAllowed,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await tripPublishRepo.tripPublish(
        userId: userId,
        originLat: originLat,
        originLong: originLong,
        originAddress: originAddress,
        originCity: originCity,
        destinationLat: destinationLat,
        destinationLong: destinationLong,
        destinationAddress: destinationAddress,
        destinationCity: destinationCity,
        deptDate: deptDate,
        arrivalDate: arrivalDate,
        deptTime: deptTime,
        arrivalTime: arrivalTime,
        vehicleId: vehicleId,
        price: price,
        availableSeats: availableSeats,
        luggageAllowed: luggageAllowed,
        petAllowed: petAllowed,
        smokingAllowed: smokingAllowed,
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

  void setDetail(LoadOfferData newData) {
    data = newData;
    notifyListeners();
  }

  void clearDetail() {
    data = null;
    notifyListeners();
  }
}
