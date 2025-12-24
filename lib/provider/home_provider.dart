import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  // Seat counter 

  int _seats=1;
  int get seats=>_seats;

  void increment(){

    if(_seats<7){
      _seats++;

      notifyListeners();
    }
  }

  void decrement(){
    if(_seats>1){
      _seats--;
      notifyListeners();
    }
  }



}