import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/auth/login_model.dart';

class LoginRepo {
  Future<LoginModel> login({
    required String number,
    required String password,
  }) async {
    Map<String, dynamic> body = {"phone_number": number, "password": password};
    return apiMethods.post(
      endpoint: "user/login",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return LoginModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message'] ?? "Invalid Credential");
        }
      },
    );
  }
}

final LoginRepo loginRepo = LoginRepo();
