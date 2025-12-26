import 'package:flutter/material.dart';

class HomeController {
  TextEditingController originController = TextEditingController();
  TextEditingController originCityController = TextEditingController();
  TextEditingController originLatController = TextEditingController();
  TextEditingController originLongController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController destinationCityController = TextEditingController();
  TextEditingController destinationLatController = TextEditingController();
  TextEditingController destinationLongController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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
