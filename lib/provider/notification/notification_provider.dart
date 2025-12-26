import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void setCount(int value) {
    _count = value;
    notifyListeners();
  }

  void decreaseCount(int value) {
    _count -= value;
    if (_count < 0) _count = 0;
    notifyListeners();
  }

  void incrementCount(int value) {
    _count += value;
    notifyListeners();
  }
}
