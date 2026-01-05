import 'package:flutter/material.dart';
import 'package:runaar/models/auth/forgot_password_model.dart';
import 'package:runaar/repos/auth/forgot_password_repo.dart';

class ForgotPasswordProvider extends ChangeNotifier {

  String? _errorMessage;
  bool _isLoading=false;
  ForgotPasswordModel?_response;

  String? get errorMessage=>_errorMessage;
  bool get isLoading=>_isLoading;
  ForgotPasswordModel? get response =>_response;


  Future<void>forgotPassword({required int user_id, required String mobile })async{



    _errorMessage=null;
    _isLoading=true;
    notifyListeners();
    try{

       final result= await forgotPasswordRepo.forgotPassword(UserId: user_id, mobileNumber: mobile);

       _response=result;

      
    } catch (e) {
      _errorMessage = "Unexpected error: ${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();



    }

  }

}