import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_list_model.dart';
import 'package:runaar/repos/vehicle/vehicle_list_repo.dart';

class VehicleListProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  VehicleListModel? _response;

  String? get errorMessage => _errorMessage;
  bool? get isLoading => _isLoading;
  VehicleListModel? get response => _response;

  Future<void> vehicleList({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      
      final result = await vehicleListRepo.vehicleList(userId: userId);
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("Error vehicle list model $e");
    } catch (e) {
      _errorMessage = "Unexpected error :${e.toString()} ";

      debugPrint("Error vehicle list model $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
