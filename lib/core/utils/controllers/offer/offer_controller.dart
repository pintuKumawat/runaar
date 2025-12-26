import 'package:flutter/material.dart';

class OfferController {
  final TextEditingController originController = TextEditingController();
  final TextEditingController originCityController = TextEditingController();
  final TextEditingController originLatController = TextEditingController();
  final TextEditingController originLongController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController destinationCityController = TextEditingController();
  final TextEditingController destinationLatController = TextEditingController();
  final TextEditingController destinationLongController = TextEditingController();
  final TextEditingController originDateController = TextEditingController();
  final TextEditingController destinationDateController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

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
