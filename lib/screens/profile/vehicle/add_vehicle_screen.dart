import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:runaar/core/responsive/responsive_extension.dart';

class AddVehicleScreen extends StatefulWidget {
  final int userId;
  const AddVehicleScreen({super.key, required this.userId});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  final brandCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final numberCtrl = TextEditingController();
  final seatsCtrl = TextEditingController();
  final colorCtrl = TextEditingController();

  String vehicleType = "Sedan";
  String fuelType = "Petrol";

  File? vehicleImage;
  File? rcImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    brandCtrl.dispose();
    modelCtrl.dispose();
    numberCtrl.dispose();
    seatsCtrl.dispose();
    colorCtrl.dispose();
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

              /// IMAGES
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
      style: theme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        
      ),
    );
  }

  // -------------------- TEXT FIELD --------------------
  Widget _textField(
    TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }

  // -------------------- DROPDOWN --------------------
  Widget _dropdownField({
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required TextTheme textTheme,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: Colors.white,
      style: textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
    );
  }

  // -------------------- IMAGE SECTION --------------------
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
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
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

  // -------------------- PICK IMAGE --------------------
  Future<void> _pickImage({required Function(File) onPicked}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  // -------------------- IMAGE PREVIEW --------------------
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
        child: ElevatedButton(
          onPressed: _saveVehicle,
          child: Text("Save Vehicle"),
        ),
      ),
    );
  }

  // -------------------- SAVE --------------------
  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    if (vehicleImage == null || rcImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please upload all images")));
      return;
    }

    // 🔗 API / Provider integration

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Vehicle added successfully")));
  }
}
