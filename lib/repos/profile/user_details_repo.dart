import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/user_details_model.dart';

class UserDetailsRepo {

  Future<UserDetailsModel>userDetails({

   required int userId

  })async{

     Map<String, dynamic> body = {
      "user_id": userId,
     };

      return apiMethods.post(
      endpoint: "user/user_detail",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return UserDetailsModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );

  }
}
UserDetailsRepo userDetailsRepo=UserDetailsRepo();