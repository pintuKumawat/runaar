import 'package:flutter/material.dart';

class HomeController {
  final TextEditingController originController = TextEditingController();
  final TextEditingController originCityController = TextEditingController();
  final TextEditingController originLatController = TextEditingController();
  final TextEditingController originLongController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController destinationCityController = TextEditingController();
  final TextEditingController destinationLatController = TextEditingController();
  final TextEditingController destinationLongController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

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
