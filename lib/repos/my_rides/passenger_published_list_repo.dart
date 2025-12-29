import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/passenger_published_list_model.dart';

class PassengerPublishedListRepo {
  Future<PassengerPublishedListModel> passengerList({
    required int tripId,
  }) async {
    Map<String, dynamic> body = {"trip_id": tripId};
    return apiMethods.post(
      endpoint: "trip/passengers",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return PassengerPublishedListModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final PassengerPublishedListRepo passengerPublishedListRepo =
    PassengerPublishedListRepo();
