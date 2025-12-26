import 'package:flutter/material.dart';

class OfferController {
  int selectedVehicleId = 0;
  final TextEditingController originController = TextEditingController();
  final TextEditingController originCityController = TextEditingController();
  final TextEditingController originLatController = TextEditingController();
  final TextEditingController originLongController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController destinationCityController =
      TextEditingController();
  final TextEditingController destinationLatController =
      TextEditingController();
  final TextEditingController destinationLongController =
      TextEditingController();
  
  final TextEditingController priceController = TextEditingController();

  void clear() {
    originController.clear();
    originCityController.clear();
    originLatController.clear();
    originLongController.clear();
    destinationController.clear();
    destinationCityController.clear();
    destinationLatController.clear();
    destinationLongController.clear();
    priceController.clear();
    selectedVehicleId = 0;
  }

  void dispose() {
    originController.dispose();
    originCityController.dispose();
    originLatController.dispose();
    originLongController.dispose();
    destinationController.dispose();
    destinationCityController.dispose();
    destinationLatController.dispose();
    destinationLongController.dispose();
    priceController.dispose();
  }
}

final OfferController offerController = OfferController();
