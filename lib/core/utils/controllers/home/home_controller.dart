import 'package:flutter/material.dart';

class HomeController {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void clear() {
    originController.clear();
    destinationController.clear();
    dateController.clear();
  }

  void dispose() {
    originController.dispose();
    destinationController.dispose();
    dateController.dispose();
  }
}

final HomeController homeController = HomeController();
