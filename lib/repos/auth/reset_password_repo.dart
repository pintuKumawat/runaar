import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/account/reset_password_model.dart';

class ResetPasswordRepo {
  Future<ResetPasswordModel> resetPassword({
    required String mobNumber,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      "phone_number": mobNumber,
      "new_password": password,
    };
    return apiMethods.post(
      endpoint: "forgot_password/reset",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString() == 'success') {
          return ResetPasswordModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message'] ?? "Something went wrong");
        }
      },
    );
  }
}

final ResetPasswordRepo resetPasswordRepo = ResetPasswordRepo();
