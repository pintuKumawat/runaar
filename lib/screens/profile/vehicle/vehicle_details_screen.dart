import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/vehicle/vehicle_details_model.dart';
import 'package:runaar/provider/vehicle/vehicle_details_provider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int vehicleId;
  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final Map<String, dynamic> vehicle = {
    "brand": "Hyundai",
    "model": "Creta",
    "number": "RJ 14 CD 5678",
    "type": "SUV",
    "fuel": "Petrol",
    "seats": "5",
    "color": "Black",
    "vehicleImage": null,
    "rcImage": null,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  Future<void> loadData() async {
    await context.read<VehicleDetailsProvider>().vehicleDetails(
      vehicleId: widget.vehicleId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Vehicle Details")),
      body: Consumer<VehicleDetailsProvider>(
        builder: (context, vehicleProvider, child) {
          final data = vehicleProvider.response?.vehicleDetail;
          return vehicleProvider.isLoading!
              ? const Center(child: CircularProgressIndicator())
              : vehicleProvider.errorMesssage != null
              ? Center(child: Text(vehicleProvider.errorMesssage ?? ""))
              : SingleChildScrollView(
                  padding: 10.all,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      _sectionTitle("Basic Information", textTheme),
                      12.height,

                      _detailTile("Brand", data?.brand ?? "", textTheme),
                      _detailTile("Model", data?.model ?? "", textTheme),
                      _detailTile(
                        "Vehicle Number",
                        data?.vehicleNumber ?? "",
                        textTheme,
                      ),
                      _detailTile(
                        "Vehicle Type",
                        data?.vehicleType ?? "",
                        textTheme,
                      ),
                      _detailTile("Fuel Type", data?.fuelType ?? "", textTheme),
                      _detailTile(
                        "Seats",
                        data?.seats.toString() ?? "",
                        textTheme,
                      ),
                      _detailTile("Color", data?.color ?? "", textTheme),
                      24.height,
                      _imageSection(textTheme, data),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _imageSection(TextTheme theme, VehicleDetail? data) {
    return Row(
      children: [
        Expanded(
          child: _imageCard(
            label: "Vehicle Image",
            image: data?.vehicleImageUrl,
            theme: theme,
          ),
        ),
        12.width,
        Expanded(
          child: _imageCard(
            label: "RC Image",
            image: data?.rcImageUrl,
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
      crossAxisAlignment: .center,
      children: [
        InkWell(
          onTap: image != null ? () => _showImageDialog(image) : null,
          child: Container(
            height: 140.h,
            width: 200.w,
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
                    child: CachedNetworkImage(
                      imageUrl: "${apiMethods.baseUrl}/$image",
                      fit: BoxFit.contain,
                    ),
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
      style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
