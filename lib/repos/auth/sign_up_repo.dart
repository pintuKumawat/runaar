import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/auth/sign_up_model.dart';

class SignUpRepo {
  Future<SignUpModel> signUp({
    required String name,
    required String email,
    required String number,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "password": password,
      "phone_number": number,
    };
    return apiMethods.post(
      endpoint: "user/signup",
      body: body,
      onSuccess: (responseData) {
        if (responseData['status'].toString().toLowerCase() == 'success') {
          return SignUpModel.fromJson(responseData);
        } else {
          throw ApiException(responseData['message'] ?? "User Already Exist");
        }
      },
    );
  }
}

final SignUpRepo signUpRepo = SignUpRepo();
