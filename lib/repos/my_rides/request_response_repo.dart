import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/request_response_model.dart';

class RequestResponseRepo {
  Future<RequestResponseModel> requestResponse({
    required int bookingId,
    required String status,
  }) async {
    Map<String, dynamic> body = {"booking_id": bookingId, "status": status};
    return apiMethods.post(
      endpoint: "booking/status",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return RequestResponseModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final RequestResponseRepo requestResponseRepo = RequestResponseRepo();
