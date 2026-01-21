import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/notification/get_notification_model.dart';

class GetNotificationRepo {
  Future<GetNotificationModel> getNotification({required int userId}) async {
    Map<String, dynamic> body = {"user_id": userId};
    return apiMethods.post(
      endpoint: "get_notification",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return GetNotificationModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message']);
        }
      },
    );
  }
}

final GetNotificationRepo getNotificationRepo = GetNotificationRepo();
