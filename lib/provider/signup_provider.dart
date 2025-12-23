import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier  {
    final TextEditingController signUserController = TextEditingController();
    final TextEditingController signPhoneController = TextEditingController();
    final TextEditingController signEmailController = TextEditingController();
  final TextEditingController signPasswordController = TextEditingController();

String? userNameError;
String? emailError;
String? phoneNumberError;
String? passwordError;

bool isloading =false;
bool isPasswordVisible=false;

void togglePasswordVisibility(){
  isPasswordVisible=!isPasswordVisible;
  notifyListeners();
}
void userNameValidate(String value){
  if(value.isEmpty){
    userNameError="user name is requiree";
  }else if(value.length<2){
    userNameError="user name have atleast 2 character";
  }else{
    userNameError=null;
  }
  notifyListeners();
}

void emailValidate(String value){
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if(value.isEmpty){
    emailError="Email is required";
  }else if(!emailRegex.hasMatch(value)){
    emailError="Plese Enter valid mail";
  }else{
    emailError=null;
  }
notifyListeners();

}

void validMobileNumber(String value){

  if(value.isEmpty){

    phoneNumberError="Please Enter mobile number";
  }else if(value.length<10){
    phoneNumberError=" Please Enter valid mobile number";

  }else{
    phoneNumberError=null;

  }

  notifyListeners();


}

void validPassword(String value){

  final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');

  if(value.isEmpty){
    passwordError="Please Enter password";

  }else if(!passwordRegex.hasMatch(value)){
    passwordError="Please Enter Valid Password";
    

  }else{
    passwordError=null;

  }

}

validAll(){

}



}