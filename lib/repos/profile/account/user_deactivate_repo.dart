import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/account/user_deactivate_model.dart';

class UserDeactivateRepo {


  Future<UserDeactivateModel>userDeactivate({required int userId})async{

    Map<String,dynamic>body={
      "user_id":userId,

    };
    return apiMethods.post(endpoint: "user/deactivate", body: body, onSuccess: (responseData){

      if(responseData["status"].toString().toLowerCase()=="success"){
        return UserDeactivateModel.fromJson(responseData); 
      }else{
        throw ApiException(responseData["message"]);
      }
    });


  }
}

UserDeactivateRepo userDeactivateRepo = UserDeactivateRepo();
