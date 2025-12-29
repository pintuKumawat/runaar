import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_details_model.dart';
import 'package:runaar/repos/vehicle/details_vechile_repo.dart';

class VehicleDetailsProvider extends ChangeNotifier {

  String? _errorMessage;
  bool _isLoading = false;
  VehicleDetailsModel? _response;

  String? get errorMesssage=>_errorMessage;
  bool? get isLoading=>_isLoading;
  VehicleDetailsModel? get response=>_response;

  Future<void> vehicleDetails({required int vehicleId})async{
    _isLoading =true;
    _errorMessage=null;
    notifyListeners();
    try{
      final result=await detailsVechileRepo.vehicleDetails(id: vehicleId);
      _response=result;
    }on ApiException catch (e){
      _errorMessage=e.message;
      debugPrint("Error details model$e");
    }catch(e){
      _errorMessage="Unexpected error : ${e.toString()}";

      debugPrint("Error delete model $e");
    }finally{
      _isLoading=false;
      notifyListeners();
    }

   


  }


}