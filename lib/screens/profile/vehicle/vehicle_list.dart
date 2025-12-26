import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/provider/vehicle/delete_vehicle_provider.dart';
import 'package:runaar/screens/profile/vehicle/vehicle_details_screen.dart';

class VehicleList extends StatefulWidget {
  final int userId;
  const VehicleList({super.key, required this.userId});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  // ---------------- MOCK DATA ----------------
  final List<Map<String, String>> vehicles = [
    {
      "brand": "Maruti Suzuki",
      "model": "Swift",
      "number": "DL 01 AB 1234",
      "image":
          "https://www.nicepng.com/png/detail/258-2589212_choose-your-swift-suzuki-swift-18-plate.png",
    },
    {
      "brand": "Hyundai",
      "model": "Creta",
      "number": "RJ 14 CD 5678",
      "image":
          "https://imgd.aeplcdn.com/664x374/n/cw/ec/41564/hyundai-creta-right-front-three-quarter9.jpeg?q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("My Vehicles")),
      body: vehicles.isEmpty
          ? Center(
              child: Text("No vehicles added", style: textTheme.bodyMedium),
            )
          : ListView.builder(
              padding: 10.all,
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final data = vehicles[index];
                return _vehicleTile(data, index, textTheme);
              },
            ),
    );
  }

  Widget _vehicleTile(
    Map<String, String> data,
    int index,
    TextTheme textTheme,
  ) {
    return Card(
      child: ListTile(
        contentPadding: .only(left: 12.w),
        onTap: () => appNavigator.push(VehicleDetailsScreen(vehicleId: 1)),
        leading: CircleAvatar(
          radius: 30.r,
          backgroundColor: Colors.transparent,
          child: Image.network(
            data["image"]!,
            width: 60.w,
            height: 60.w,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Container(
              width: 60.w,
              height: 60.w,
              color: Colors.grey.shade300,
              child: Icon(Icons.directions_car, size: 26.sp),
            ),
          ),
        ),

        /// TITLE & SUBTITLE
        title: Text(
          "${data["brand"]} ${data["model"]}",
          style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Car No: ${data["number"]}",
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),

        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () => _onDeleteVehicle(index),
        ),
      ),
    );
  }

  // -------------------- DELETE VEHICLE --------------------
  void _onDeleteVehicle(int index) {
    showDialog(
      context: context,
      builder: (_) => Consumer<DeleteVehicleProvider>(
        builder: (BuildContext context, deleteVehicleProvider, child) {
          return AlertDialog(
            backgroundColor: appColor.buttonColor,
            title: const Text("Delete Vehicle"),
            content: const Text(
              "Are you sure you want to delete this vehicle?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await deleteVehicleProvider.deleteVehicle(vehicleId: 1);
                  if (deleteVehicleProvider.errorMessage != null) {
                    appSnackbar.showSingleSnackbar(
                      context,
                      deleteVehicleProvider.errorMessage ?? "",
                    );

                    return;
                  }
                  appSnackbar.showSingleSnackbar(
                    context,
                    deleteVehicleProvider.response?.message ?? "",
                  );

                  // appNavigator.pop();
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      ),
    );
  }
}
