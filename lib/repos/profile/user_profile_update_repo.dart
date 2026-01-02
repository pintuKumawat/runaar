import 'dart:io';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/user_profile_update_model.dart';

class UserProfileUpdateRepo {
  Future<UserProfileUpdateModel> updateProfile({
    required int userId,
    required String dob,
    required String gender,
    required File? profileImage,
    required String name,
    required String email,
  }) async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "dob": dob,
      "gender": gender,
      "name": name,
      "email": email,
    };

    if (profileImage != null) {
      Map<String, File> files = {"profile_image": profileImage};

      return apiMethods.postMultipart(
        endpoint: "user/profile_update",
        fields: body,
        files: files,
        onSuccess: (responseData) {
          if (responseData['status'].toString().toLowerCase() == 'success') {
            return UserProfileUpdateModel.fromJson(responseData);
          } else {
            throw ApiException(responseData['message']);
          }
        },
      );
    } else {
      return apiMethods.post(
        endpoint: "user/profile_update",
        body: body,
        onSuccess: (responseData) {
          if (responseData['status'].toString().toLowerCase() == 'success') {
            return UserProfileUpdateModel.fromJson(responseData);
          } else {
            throw ApiException(responseData['message']);
          }
        },
      );
    }
  }
}

final UserProfileUpdateRepo userProfileUpdateRepo = UserProfileUpdateRepo();
