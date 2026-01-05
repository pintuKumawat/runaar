import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/trip_status_update_model.dart';

class TripStatusUpdateRepo {
  Future<TripStatusUpdateModel> statusUpdate({
    required int tripId,
    required String status,
  }) async {
    Map<String, dynamic> body = {"id": tripId, "trip_status": status};
    return apiMethods.post(
      endpoint: "trip/status_update",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return TripStatusUpdateModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final TripStatusUpdateRepo tripStatusUpdateRepo = TripStatusUpdateRepo();
