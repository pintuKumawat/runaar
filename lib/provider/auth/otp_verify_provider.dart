import 'package:flutter/material.dart';
import 'package:runaar/models/auth/otp_verify_model.dart';
import 'package:runaar/repos/auth/otp_verify_repo.dart';

class OtpVerifyProvider extends ChangeNotifier {

  String? _errorMessage;
  bool _isLoading=false;
  OtpVerifyModel?_response;

  String? get errorMessage=>_errorMessage;
  bool get isLoading=>_isLoading;
  OtpVerifyModel?get response=>_response;



  Future<void>otpVerify({required int userId,required String otp})async{
    _errorMessage=null;
    _isLoading=true;
    notifyListeners();

    try{
      final result=await otpVerifyRepo.otpVerify(userId: userId, otp: otp);

      _response=result;

    }catch(e){
      _errorMessage="Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    }finally {
      _isLoading=false;

      notifyListeners();
    }
    


  }

}