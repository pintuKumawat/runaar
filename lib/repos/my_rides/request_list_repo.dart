import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/request_list_model.dart';

class RequestListRepo {
  Future<RequestListModel> requestList({required int userId}) async {
    Map<String, dynamic> body = {"user_id": userId};
    return apiMethods.post(
      endpoint: "trip/request_list",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return RequestListModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final RequestListRepo requestListRepo = RequestListRepo();
