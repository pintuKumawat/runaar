import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/auth/otp_verify_model.dart';

class OtpVerifyRepo {

Future<OtpVerifyModel>otpVerify({required int userId,required String otp
})async{
  Map<String,dynamic> body={"user_id":userId,"otp":otp};

  return apiMethods.post(endpoint: "forgot_password/verify", body: body, onSuccess: (responseData){
    if(responseData['status'].toString()=='success'){
      return OtpVerifyModel.fromJson(responseData);
    }else{
      throw ApiException(responseData['message']??"Something went wrong");
    }
  });

}  
}OtpVerifyRepo otpVerifyRepo=OtpVerifyRepo();