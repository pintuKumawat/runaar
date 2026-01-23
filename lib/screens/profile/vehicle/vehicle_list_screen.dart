import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/models/vehicle/vehicle_list_model.dart';
import 'package:runaar/provider/vehicle/delete_vehicle_provider.dart';
import 'package:runaar/provider/vehicle/vehicle_list_provider.dart';
import 'package:runaar/screens/profile/vehicle/vehicle_details_screen.dart';

class VehicleListScreen extends StatefulWidget {
  final int userId;
  const VehicleListScreen({super.key, required this.userId});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  Future<void> _fetchData() async {
    await context.read<VehicleListProvider>().vehicleList(
      userId: widget.userId,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Vehicles")),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Consumer<VehicleListProvider>(
          builder: (context, vehicleProvider, _) {
            final vehicleData = vehicleProvider.response?.data ?? [];

            return (vehicleProvider.isLoading == true)
                ? Center(child: CircularProgressIndicator())
                : (vehicleProvider.errorMessage != null)
                ? Center(
                    child: Text(
                      vehicleProvider.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: 10.all,
                    itemCount: vehicleData.length,
                    itemBuilder: (context, index) {
                      final data = vehicleData[index];
                      return _vehicleTile(
                        data,
                        index,
                        Theme.of(context).textTheme,
                      );
                    },
                  );
          },
        ),
      ),
    );
  }

  Widget _vehicleTile(Data data, int index, TextTheme textTheme) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12.w),
        onTap: () => appNavigator.push(
          VehicleDetailsScreen(vehicleId: data.vehicleId ?? 0),
        ),
        leading: SizedBox(
          width: 56.r,
          height: 56.r,
          child: CachedNetworkImage(
            imageUrl: "${apiMethods.baseUrl}/${data.vehicleImage}",
            imageBuilder: (context, imageProvider) =>
                CircleAvatar(backgroundImage: imageProvider),
            errorWidget: (_, _, _) => CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.directions_car, size: 26.sp),
            ),
          ),
        ),

        title: Row(
          mainAxisSize: .min,
          children: [
            Text(
              "${data.vehicleBrand} ${data.model}",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            3.width,
            Icon(
              Icons.verified,
              size: 14.sp,
              color: data.isVerified == 1 ? Colors.green : Colors.grey,
            ),
          ],
        ),
        subtitle: Text(
          "Car No: ${data.vehicleNumber}",
          style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        ),
        trailing: IconButton(
          icon: const InkWell(
            child: SizedBox(width: 40, height: 40, child: Icon(Icons.delete)),
          ),
          color: Colors.red,
          onPressed: () => _onDeleteVehicle(data.vehicleId ?? 0),
        ),
      ),
    );
  }

  void _onDeleteVehicle(int vehicleId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: appColor.mainColor.withOpacity(.7),
      builder: (_) => Consumer<DeleteVehicleProvider>(
        builder: (context, deleteVehicleProvider, child) {
          return AlertDialog(
            backgroundColor: appColor.buttonColor,
            title: const Text("Delete Vehicle"),
            content: const Text(
              "Are you sure you want to delete this vehicle?",
            ),
            actions: [
              TextButton(
                onPressed: () => appNavigator.pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await deleteVehicleProvider.deleteVehicle(
                    vehicleId: vehicleId,
                  );
                  if (deleteVehicleProvider.errorMessage != null) {
                    appNavigator.pop();
                    return appSnackbar.showSingleSnackbar(
                      context,
                      deleteVehicleProvider.errorMessage ?? "",
                    );
                  }
                  appSnackbar.showSingleSnackbar(
                    context,
                    deleteVehicleProvider.response?.message ?? "",
                  );

                  appNavigator.pop();
                  await _fetchData();
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
