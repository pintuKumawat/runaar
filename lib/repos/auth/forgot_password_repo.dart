import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/auth/forgot_password_model.dart';

class ForgotPasswordRepo {
  Future<ForgotPasswordModel> forgotPassword({
    required String mobileNumber,
  }) async {
    Map<String, dynamic> body = {"phone_number": mobileNumber};

    return apiMethods.post(
      endpoint: "forgot_password/request",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString() == 'success') {
          return ForgotPasswordModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message'] ?? "Something went wrong");
        }
      },
    );
  }
}

ForgotPasswordRepo forgotPasswordRepo = ForgotPasswordRepo();
