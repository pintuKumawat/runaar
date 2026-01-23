import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/offer/offer_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/core/utils/helpers/location_picker_sheet/location_picker_bottom.dart';
import 'package:runaar/core/utils/helpers/offer_ride/load_offer_data.dart';
import 'package:runaar/provider/notification/notification_provider.dart';
import 'package:runaar/provider/offerProvider/offer_provider.dart';
import 'package:runaar/provider/vehicle/active_vehicle_provider.dart';
import 'package:runaar/screens/offer/offer_ride_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfferRide extends StatefulWidget {
  const OfferRide({super.key});

  @override
  State<OfferRide> createState() => _OfferRideState();
}

class _OfferRideState extends State<OfferRide> {
  DateTime departureDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();

  int userId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getuserId().then((_) {
        context.read<ActiveVehicleProvider>().vehicleList(userId: userId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OFFER RIDE'),
        actions: [
          Stack(
            children: [
              Icon(Icons.notifications, size: 26.sp),
              Consumer<NotificationProvider>(
                builder: (context, value, child) => Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 7.r,
                    backgroundColor: Colors.red,
                    child: Text(
                      value.count.toString(),
                      style: theme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await context
            .read<ActiveVehicleProvider>()
            .vehicleList(userId: userId),
        child: SingleChildScrollView(
          padding: 10.all,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Offer a Ride', style: theme.titleMedium),
              16.height,

              _inputTile(
                icon: Icons.my_location,
                hint: 'Enter Pickup Location',
                theme: theme,
                controller: offerController.originController,
                type: 'pickup',
              ),
              _inputTile(
                icon: Icons.location_on,
                hint: 'Enter Drop Location',
                theme: theme,
                controller: offerController.destinationController,
                type: 'drop',
              ),
              Text('Select Car', style: theme.titleMedium),
              6.height,
              _vehicleSelector(theme),

              // 6.height,
              _dateTile(
                title: 'Date of Departure',
                date: departureDate,
                onTap: _pickDepartureDate,
                theme: theme,
              ),

              12.height,
              _dateTile(
                title: 'Date of Arrival',
                date: arrivalDate,
                onTap: _pickArrivalDate,
                theme: theme,
              ),

              28.height,

              SizedBox(
                width: double.infinity,
                height: 40.h,
                child: ElevatedButton(
                  onPressed: _loadData,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car, size: 20.sp),
                      6.width,
                      const Text('OFFER RIDE'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    final provider = context.read<OfferProvider>();
    String arrivalTime = _formatTime(arrivalDate);
    String deptTime = _formatTime(departureDate);

    if (arrivalTime.isEmpty || deptTime.isEmpty) {
      return appSnackbar.showSingleSnackbar(context, "Time cannot be empty");
    } else if (offerController.destinationController.text.isEmpty ||
        offerController.originController.text.isEmpty) {
      return appSnackbar.showSingleSnackbar(
        context,
        "Locations cannot be empty",
      );
    } else if (offerController.destinationController.text ==
        offerController.originController.text) {
      return appSnackbar.showSingleSnackbar(
        context,
        "Both location cannot be same",
      );
    } else if (offerController.selectedVehicleId == 0) {
      return appSnackbar.showSingleSnackbar(
        context,
        "Please select your vehicle",
      );
    } else if (arrivalTime == deptTime) {
      return appSnackbar.showSingleSnackbar(
        context,
        "Both Time cannot be same",
      );
    } else {
      final data = LoadOfferData(
        userId: userId,
        originLat: offerController.originLatController.text,
        originLong: offerController.originLongController.text,
        originAddress: offerController.originController.text,
        originCity: offerController.originCityController.text,
        destinationLat: offerController.destinationLatController.text,
        destinationLong: offerController.destinationLongController.text,
        destinationAddress: offerController.destinationController.text,
        destinationCity: offerController.destinationCityController.text,
        deptDate:
            '${departureDate.year}-${departureDate.month}-${departureDate.day}',
        arrivalDate:
            '${arrivalDate.year}-${arrivalDate.month}-${arrivalDate.day}',
        deptTime: deptTime,
        arrivalTime: arrivalTime,
        vehicleId: offerController.selectedVehicleId,
      );

      provider.setDetail(data);

      if (!mounted) return;
      return appNavigator.push(OfferRideDetailsScreen());
    }
  }

  Widget _inputTile({
    required IconData icon,
    required String hint,
    required TextTheme theme,
    required String type,
    required TextEditingController controller,
  }) {
    return Container(
      margin: .only(bottom: 12.h),
      padding: 12.all,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: TextField(
        inputFormatters: [FirstLetterCapitalFormatter()],
        controller: controller,
        readOnly: true,
        onTap: () => openLocationPicker(type),
        style: theme.bodyLarge,
        decoration: InputDecoration(
          icon: Icon(icon, size: 24.sp),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _vehicleSelector(TextTheme theme) {
    ActiveVehicleProvider provider = context.watch<ActiveVehicleProvider>();
    final vehicleData = provider.response?.data ?? [];

    if (provider.isLoading == true) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vehicleData.isEmpty) {
      return Container(
        padding: 12.all,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(14.r),
        ),
        child: Text("No vehicles added", style: theme.bodyMedium),
      );
    }

    return Container(
      margin: .only(bottom: 12.h),
      padding: .symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          dropdownColor: Colors.white,
          value: offerController.selectedVehicleId == 0
              ? null
              : offerController.selectedVehicleId,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 22.sp),
          hint: Row(
            children: [
              Icon(Icons.directions_car, size: 18.sp, color: Colors.grey),
              10.width,
              Text(
                "Select Car",
                style: theme.bodyLarge?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          items: vehicleData.map((v) {
            return DropdownMenuItem(
              value: v.vehicleId,
              child: Row(
                children: [
                  Icon(Icons.directions_car, size: 18.sp),
                  10.width,
                  Expanded(
                    child: Text(
                      "${v.vehicleBrand} ${v.model} (${v.vehicleNumber})",
                      overflow: .ellipsis,
                      style: theme.bodyLarge,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => offerController.selectedVehicleId = value!);
          },
        ),
      ),
    );
  }

  Future<void> getuserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(savedData.userId);
    setState(() {
      userId = id ?? 0;
    });
  }

  Future<void> _pickDepartureDate() async {
    // Pick date first
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Pick time after date
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      departureDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      if (arrivalDate.isBefore(departureDate)) {
        arrivalDate = departureDate;
      }
    });
  }

  Future<void> _pickArrivalDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: arrivalDate.isBefore(departureDate)
          ? departureDate
          : arrivalDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
      firstDate: departureDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        pickedDate.isAtSameMomentAs(
              DateTime(
                departureDate.year,
                departureDate.month,
                departureDate.day,
              ),
            )
            ? departureDate
            : DateTime.now(),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final newArrival = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (newArrival.isBefore(departureDate)) {
      appSnackbar.showSingleSnackbar(
        context,
        "Arrival time cannot be before departure time",
      );
      return;
    }

    setState(() {
      arrivalDate = newArrival;
    });
  }

  Widget _dateTile({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
    required TextTheme theme,
  }) {
    String dateTime = _formatDateTime(date);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: 18.hv(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.bodySmall),
                4.height,
                Text(
                  dateTime,
                  style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Icon(Icons.calendar_month, size: 22.sp),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');

    return '$d/$m/$y $h:$min';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> openLocationPicker(String type) async {
    final result = await showModalBottomSheet<AutocompletePrediction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) =>
          LocationPickerBottomSheet(type: type, screenType: "offer"),
    );

    if (result != null) {
      // Update text fields when user selects location
      if (type == 'pickup') {
        offerController.originController.text = result.fullText;
      } else {
        offerController.destinationController.text = result.fullText;
      }
    }
  }
}
