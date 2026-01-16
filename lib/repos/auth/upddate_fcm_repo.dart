import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/auth/update_fcm_model.dart';

class UpddateFcmRepo {
  Future<UpdateFcmModel> updateFcm({
    required int userId,
    required String fcmToken,
  }) async {
    Map<String, dynamic> body = {"user_id": userId, "fcm_token": fcmToken};
    return apiMethods.post(
      endpoint: "update/fcm_token",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString() == 'success') {
          return UpdateFcmModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message'] ?? "Something went wrong");
        }
      },
    );
  }
}

final UpddateFcmRepo upddateFcmRepo = UpddateFcmRepo();
