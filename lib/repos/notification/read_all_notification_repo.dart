import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/notification/readl_all_notification_model.dart';

class ReadAllNotificationRepo {
  Future<ReadlAllNotificationModel> readNotification({
    required int userId,
  }) async {
    Map<String, dynamic> body = {"user_id": userId};
    return apiMethods.post(
      endpoint: "marked_all_notification",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return ReadlAllNotificationModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message']);
        }
      },
    );
  }
}

final ReadAllNotificationRepo readAllNotificationRepo =
    ReadAllNotificationRepo();
