import 'package:flutter/material.dart';

class AddVehicleController {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController seatsController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  void clear() {
    brandController.clear();
    modelController.clear();
    numberController.clear();
    seatsController.clear();
    colorController.clear();
  }

  void dispose() {
    brandController.dispose();
    modelController.dispose();
    numberController.dispose();
    seatsController.dispose();
    colorController.dispose();
  }
}

final AddVehicleController addVehicleController = AddVehicleController();
