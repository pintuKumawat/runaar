import 'dart:io';

import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/add_vehicle_model.dart';

class AddVehicleRepo {
  Future<AddVehicleModel> addVehicle({
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
    Map<String, dynamic> body = {
      "user_id": userId,
      "brand": brand,
      "model": vModel,
      "vehicle_number": vNumber,
      "vehicle_type": vType,
      "fuel_type": fType,
      "seats": seats,
      "color": color,
    };

    Map<String, File> files = {
      "vehicle_image_url": vImage,
      "rc_image_url": rcImage,
    };

    return apiMethods.postMultipart(
      endpoint: "vehicle/add",
      fields: body,
      files: files,
      onSuccess: (responseData) {
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return AddVehicleModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message']);
        }
      },
    );
  }
}

final AddVehicleRepo addVehicleRepo = AddVehicleRepo();
