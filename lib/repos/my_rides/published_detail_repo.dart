import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/published_detail_model.dart';

class PublishedDetailRepo {
  Future<PublishedDetailModel> publishedDetail({required int tripId}) async {
    Map<String, dynamic> body = {"trip_id": tripId};
    return apiMethods.post(
      endpoint: "trip/trip_detail",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return PublishedDetailModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final PublishedDetailRepo publishedDetailRepo = PublishedDetailRepo();
