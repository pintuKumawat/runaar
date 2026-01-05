import 'package:flutter/material.dart';

class ForgotPasswordController {

   final TextEditingController forgotMobileController = TextEditingController();
   final TextEditingController otpVerifyController=TextEditingController();
   

   void clear(){
    forgotMobileController.clear();
   
   }

   void dispose(){
    forgotMobileController.dispose();

   }
  
}ForgotPasswordController forgotPasswordController =ForgotPasswordController();