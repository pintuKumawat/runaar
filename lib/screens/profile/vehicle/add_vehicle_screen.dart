import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/profile/vehicles/add_vehicle_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/core/utils/helpers/formatter/formater.dart'
    hide FirstLetterCapitalFormatter;
import 'package:runaar/provider/vehicle/add_vehicle_provider.dart';
import 'package:runaar/screens/profile/vehicle/vehicle_list_screen.dart';

class AddVehicleScreen extends StatefulWidget {
  final int userId;
  const AddVehicleScreen({super.key, required this.userId});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final brandCtrl = addVehicleController.brandController;
  final modelCtrl = addVehicleController.modelController;
  final numberCtrl = addVehicleController.numberController;
  final seatsCtrl = addVehicleController.seatsController;
  final colorCtrl = addVehicleController.colorController;

  String vehicleType = "Sedan";
  String fuelType = "Petrol";

  File? vehicleImage;
  File? rcImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    addVehicleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Add Vehicle")),
      bottomNavigationBar: _bottomBar(),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label("Brand Name", textTheme),
              _textField(brandCtrl),

              14.height,

              _label("Model Name", textTheme),
              _textField(modelCtrl),

              10.height,

              _label("Vehicle Number", textTheme),
              _textField(numberCtrl),

              14.height,

              _label("Vehicle Type", textTheme),
              _dropdownField(
                value: vehicleType,
                items: ["Sedan", "Hatchback", "SUV", "MPV"],
                onChanged: (v) => setState(() => vehicleType = v),
                textTheme: textTheme,
              ),

              14.height,

              _label("Fuel Type", textTheme),
              _dropdownField(
                value: fuelType,
                items: ["Petrol", "Diesel", "CNG", "Electric"],
                onChanged: (v) => setState(() => fuelType = v),
                textTheme: textTheme,
              ),

              14.height,

              _label("Number of Seats", textTheme),
              _textField(seatsCtrl, keyboardType: TextInputType.number),

              14.height,

              _label("Color", textTheme),
              _textField(colorCtrl),

              24.height,

              Row(
                children: [
                  Expanded(
                    child: _imageSection(
                      label: "Vehicle Image",
                      image: vehicleImage,
                      onPick: () => _pickImage(
                        onPicked: (file) => setState(() => vehicleImage = file),
                      ),
                    ),
                  ),
                  12.width,
                  Expanded(
                    child: _imageSection(
                      label: "RC Image",
                      image: rcImage,
                      onPick: () => _pickImage(
                        onPicked: (file) => setState(() => rcImage = file),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- LABEL --------------------
  Widget _label(String text, TextTheme theme) {
    return Text(
      text,
      style: theme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  // -------------------- TEXT FIELD --------------------
  Widget _textField(
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      inputFormatters: ctrl == numberCtrl
          ? [UpperCaseTextFormatter()]
          : [FirstLetterCapitalFormatter()],
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (ctrl == numberCtrl) {
          if (value == null || value.isEmpty) {
            return "Please enter vehicle number";
          }

          final allowedChars = RegExp(r'^[A-Za-z0-9]+$');
          if (!allowedChars.hasMatch(value)) {
            return "Only letters and numbers allowed";
          }

          if (value.length != 10) {
            return "Vehicle number must be exactly 10 characters";
          }

          final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
          final hasDigit = RegExp(r'[0-9]').hasMatch(value);
          if (!hasLetter || !hasDigit) {
            return "Must contain both letters and numbers";
          }

          return null;
        }

        if (ctrl == seatsCtrl) {
          if (value == null || value.isEmpty) {
            return "Please enter number of seats";
          }

          final seats = int.tryParse(value);
          if (seats == null) {
            return "Only numeric characters allowed";
          }

          if (seats > 7) {
            return "Seats cannot be more than 7";
          }

          return null;
        }

        if (ctrl == brandCtrl || ctrl == modelCtrl || ctrl == colorCtrl) {
          if (value == null || value.isEmpty) {
            return "Required field";
          }
          return null;
        }

        return null;
      },
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required TextTheme textTheme,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white,
      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
    );
  }

  Widget _imageSection({
    required String label,
    required File? image,
    required VoidCallback onPick,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 130.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: InkWell(
            onTap: image == null ? onPick : () => _showImageDialog(image),
            child: image == null
                ? Center(child: Icon(Icons.camera_alt, size: 36.sp))
                : ClipRRect(
                    borderRadius: .circular(10.r),
                    child: Image.file(
                      image,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
        6.height,
        Center(child: Text(label, style: textTheme.bodySmall)),
      ],
    );
  }

  Future<void> _pickImage({required Function(File) onPicked}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  void _showImageDialog(File image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(padding: 12.all, child: Image.file(image)),
      ),
    );
  }

  Widget _bottomBar() {
    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: Consumer<AddVehicleProvider>(
          builder: (context, vehicleProvider, child) => ElevatedButton(
            onPressed: () => _saveVehicle(vehicleProvider),
            child: vehicleProvider.isLoading
                ? const CircularProgressIndicator()
                : const Text("Save Vehicle"),
          ),
        ),
      ),
    );
  }

  Future<void> _saveVehicle(AddVehicleProvider vehicleProvider) async {
    if (!_formKey.currentState!.validate()) return;

    if (vehicleImage == null || rcImage == null) {
      appSnackbar.showSingleSnackbar(context, "Please upload all images");
      return;
    }

    await vehicleProvider.addVehicle(
      userId: widget.userId,
      brand: addVehicleController.brandController.text,
      vModel: addVehicleController.modelController.text,
      vNumber: addVehicleController.numberController.text,
      vType: vehicleType,
      fType: fuelType,
      seats: int.parse(seatsCtrl.text),
      color: addVehicleController.colorController.text,
      vImage: vehicleImage!,
      rcImage: rcImage!,
    );

    if (vehicleProvider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(
        context,
        vehicleProvider.errorMessage ?? "",
      );
      return;
    }
    appSnackbar.showSingleSnackbar(
      context,
      vehicleProvider.reponse?.message ?? "",
    );

    appNavigator.pushReplacement(VehicleListScreen(userId: widget.userId));
  }
}
