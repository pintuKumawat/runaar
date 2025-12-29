import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_details_model.dart';

class VehicleDetailsRepo {

  Future<VehicleDetailsModel>vehicleDetails({
    required int id
  })async{
    Map<String ,dynamic> body={"id":id};

    return apiMethods.post(endpoint: "vehicle/detail", body: body, onSuccess: (responseData){
      if(responseData["stutas"].toString().toLowerCase()=="success"){
        return VehicleDetailsModel.fromJson(responseData);

      }else{
        throw ApiException(responseData["message"]);
      }

    });
  }
}
final VehicleDetailsRepo vehicleDetailsRepo  =VehicleDetailsRepo ();