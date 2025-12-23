import 'package:flutter/material.dart';

class OfferController {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
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
