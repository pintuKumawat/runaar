import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/notification/read_notification_model.dart';

class ReadNotificationRepo {
  Future<ReadNotificationModel> readNotification({
    required int notificationId,
  }) async {
    Map<String, dynamic> body = {"notification_id": notificationId};
    return apiMethods.post(
      endpoint: "marked_notification",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return ReadNotificationModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message']);
        }
      },
    );
  }
}

final ReadNotificationRepo readNotificationRepo = ReadNotificationRepo();
