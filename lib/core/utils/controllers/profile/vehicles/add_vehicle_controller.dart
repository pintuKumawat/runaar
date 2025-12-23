import 'package:flutter/material.dart';

class AddVehicleController {
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController seatsController = TextEditingController();
  TextEditingController colorController = TextEditingController();

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
