import 'dart:io';

import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/add_vehicle_model.dart';
import 'package:runaar/repos/vehicle/add_vehicle_repo.dart';

class AddVehicleProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  AddVehicleModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AddVehicleModel? get reponse => _response;

  Future<void> addVehicle({
    required int userId,
    required String brand,
    required String vModel,
    required String vNumber,
    required String vType,
    required String fType,
    required int seats,
    required String color,
    required File vImage,
    required File rcImage,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await addVehicleRepo.addVehicle(
        userId: userId,
        brand: brand,
        vModel: vModel,
        vNumber: vNumber,
        vType: vType,
        fType: fType,
        seats: seats,
        color: color,
        vImage: vImage,
        rcImage: rcImage,
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
