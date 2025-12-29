import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_list_model.dart';

class VehicleListRepo {
  Future<VehicleListModel> vehicleList({required int userId}) async {
    Map<String, dynamic> body = {"user_id": userId};
    return apiMethods.post(
      endpoint: "vehicle/list",
      body: body,
      onSuccess: (responseData) {
       
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return VehicleListModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message']);
        }
      },
    );
  }
}

final VehicleListRepo vehicleListRepo = VehicleListRepo();
