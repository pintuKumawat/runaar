import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/published_list_model.dart';

class PublishedListRepo {
  Future<PublishedListModel> publishedlist({required int userId}) async {
    Map<String, dynamic> body = {"user_id": userId};
    return apiMethods.post(
      endpoint: "trip/published_rides_by_user",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return PublishedListModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final PublishedListRepo publishedListRepo = PublishedListRepo();
