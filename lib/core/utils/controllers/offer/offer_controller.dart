import 'package:flutter/material.dart';

class OfferController {
  TextEditingController originController = TextEditingController();
  TextEditingController originCityController = TextEditingController();
  TextEditingController originLatController = TextEditingController();
  TextEditingController originLongController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController destinationCityController = TextEditingController();
  TextEditingController destinationLatController = TextEditingController();
  TextEditingController destinationLongController = TextEditingController();
  TextEditingController originDateController = TextEditingController();
  TextEditingController destinationDateController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  void clear() {
    originController.clear();
    destinationController.clear();
    originDateController.clear();
    destinationDateController.clear();
    priceController.clear();
  }

  void dispose() {
    originController.dispose();
    destinationController.dispose();
    originDateController.dispose();
    destinationDateController.dispose();
    priceController.dispose();
  }
}

final OfferController offerController = OfferController();
