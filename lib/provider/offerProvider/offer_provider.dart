import 'package:flutter/material.dart';

class OfferProvider extends ChangeNotifier {
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