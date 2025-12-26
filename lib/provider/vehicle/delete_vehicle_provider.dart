import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_delete_model.dart';
import 'package:runaar/repos/vehicle/delete_vehicle_repo.dart';

class DeleteVehicleProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  VehicleDeleteModel? _response;

  String? get errorMessage => _errorMessage;
  bool? get isLoading => _isLoading;
  VehicleDeleteModel? get response => _response;

  Future<void> deleteVehicle({required int vehicleId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result=await deleteVehicleRepo.deleteVehicle(id: vehicleId);
      _response=result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("Error delete model $e");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()} ";

      debugPrint("Error delete model $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
