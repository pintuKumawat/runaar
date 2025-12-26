import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_delete_model.dart';

class DeleteVehicleRepo {
  Future<VehicleDeleteModel> deleteVehicle({required int id}) async {
    Map<String, dynamic> body = {"id": id};
    return apiMethods.post(
      endpoint: "vehicle/delete",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return VehicleDeleteModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final DeleteVehicleRepo deleteVehicleRepo=DeleteVehicleRepo();