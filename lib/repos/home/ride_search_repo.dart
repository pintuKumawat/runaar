import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/home/ride_search_model.dart';

class RideSearchRepo {
  Future<RideSearchModel> rideSearch({
    required String deptDate,
    required String originCity,
    required String destinationCity,
  }) async {
    Map<String, dynamic> body = {
      "dept_date": deptDate,
      "origin_city": originCity,
      "destination_city": destinationCity,
    };

    return apiMethods.post(
      endpoint: "ride/search_rides",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return RideSearchModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final RideSearchRepo rideSearchRepo = RideSearchRepo();
