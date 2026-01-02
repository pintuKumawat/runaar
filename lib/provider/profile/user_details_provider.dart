import 'package:flutter/material.dart';

import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/user_details_model.dart';
import 'package:runaar/repos/profile/user_details_repo.dart';

class UserDetailsProvider extends ChangeNotifier {

  String? _errorMessage;
  bool _isLoding=false;
  UserDetailsModel? _response;
  String?get errorMessage=>_errorMessage;
  bool get isLoading=>_isLoding;
  UserDetailsModel? get response=>_response;


  Future<void>userDetails({required int userId})async{

    _isLoding=true;
    _errorMessage=null;
    notifyListeners();

    try{
      final result=await userDetailsRepo.userDetails(userId: userId);
      _response=result;


    }on ApiException catch (e){
      _errorMessage=e.message;

      debugPrint("API Exception: $_errorMessage");



    }catch(e){
      _errorMessage="Unexpected error :${e.toString()}";
      debugPrint("❌ Unexpected error: $e");
    }finally{
      _isLoding=false;
      notifyListeners();
    }
    

  }
  
}