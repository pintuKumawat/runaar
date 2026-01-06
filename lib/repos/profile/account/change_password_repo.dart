import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/account/reset_password_model.dart';

class ChangePasswordRepo {
  Future<ResetPasswordModel> resetPassword({
    required int userId,
    required String password,
    required String newPassword,
  }) async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "password": password,
      "new_password": newPassword,
    };
    return apiMethods.post(
      endpoint: "user/reset_password",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return ResetPasswordModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final ChangePasswordRepo changePasswordRepo = ChangePasswordRepo();
