import 'dart:io';
import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/constants/app_color.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int vehicleId;
  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  // ---------------- MOCK VEHICLE DATA ----------------
  final Map<String, dynamic> vehicle = {
    "brand": "Hyundai",
    "model": "Creta",
    "number": "RJ 14 CD 5678",
    "type": "SUV",
    "fuel": "Petrol",
    "seats": "5",
    "color": "Black",
    "vehicleImage": null, // File or Network image later
    "rcImage": null,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Details"),
      ),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _imageSection(textTheme),

            24.height,

            _sectionTitle("Basic Information", textTheme),
            12.height,

            _detailTile("Brand", vehicle["brand"], textTheme),
            _detailTile("Model", vehicle["model"], textTheme),
            _detailTile("Vehicle Number", vehicle["number"], textTheme),
            _detailTile("Vehicle Type", vehicle["type"], textTheme),
            _detailTile("Fuel Type", vehicle["fuel"], textTheme),
            _detailTile("Seats", vehicle["seats"], textTheme),
            _detailTile("Color", vehicle["color"], textTheme),
          ],
        ),
      ),
    );
  }

  // -------------------- IMAGE SECTION --------------------
  Widget _imageSection(TextTheme theme) {
    return Row(
      children: [
        Expanded(
          child: _imageCard(
            label: "Vehicle Image",
            image: vehicle["vehicleImage"],
            theme: theme,
          ),
        ),
        12.width,
        Expanded(
          child: _imageCard(
            label: "RC Image",
            image: vehicle["rcImage"],
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _imageCard({
    required String label,
    required dynamic image,
    required TextTheme theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: image != null ? () => _showImageDialog(image) : null,
          child: Container(
            height: 140.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: image == null
                ? Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 36.sp,
                      color: Colors.grey,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: image is File
                        ? Image.file(image, fit: BoxFit.cover)
                        : Image.network(image, fit: BoxFit.cover),
                  ),
          ),
        ),
        6.height,
        Center(child: Text(label, style: theme.bodySmall)),
      ],
    );
  }

  // -------------------- SECTION TITLE --------------------
  Widget _sectionTitle(String text, TextTheme theme) {
    return Text(
      text,
      style: theme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        
      ),
    );
  }

  // -------------------- DETAIL TILE --------------------
  Widget _detailTile(String title, String value, TextTheme theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            title,
            style: theme.bodyMedium?.copyWith(
              color: appColor.textColor.withOpacity(.7),
            ),
          ),
          Text(
            value,
            style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // -------------------- IMAGE PREVIEW --------------------
  void _showImageDialog(dynamic image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Padding(
          padding: 12.all,
          child: image is File ? Image.file(image) : Image.network(image),
        ),
      ),
    );
  }
}
