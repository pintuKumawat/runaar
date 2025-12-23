import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/offer/offer_ride_details_screen.dart';

class OfferRide extends StatefulWidget {
  const OfferRide({super.key});

  @override
  State<OfferRide> createState() => _OfferRideState();
}

class _OfferRideState extends State<OfferRide> {
  DateTime departureDate = DateTime.now();
  DateTime arrivalDate = DateTime.now();

  String selectedVehicle = 'Van';
  final List<String> vehicles = ['Ertiga', 'Creta', 'Scorpio', 'Van'];

  /// ---------------- DATE PICKERS ----------------

  Future<void> _pickDepartureDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        departureDate = picked;
        if (arrivalDate.isBefore(departureDate)) {
          arrivalDate = departureDate;
        }
      });
    }
  }

  Future<void> _pickArrivalDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: arrivalDate,
      firstDate: departureDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => arrivalDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('OFFER RIDE'), centerTitle: true),
      body: SingleChildScrollView(
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
            ),
            _inputTile(
              icon: Icons.location_on,
              hint: 'Enter Drop Location',
              theme: theme,
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
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => appNavigator.push(OfferRideDetailsScreen()),
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
    );
  }

  Widget _inputTile({
    required IconData icon,
    required String hint,
    required TextTheme theme,
  }) {
    return Container(
      margin: .only(bottom: 12.h),
      padding: 12.all,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: TextField(
        style: theme.bodyLarge,
        decoration: InputDecoration(
          icon: Icon(icon, size: 24.sp),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _vehicleSelector(TextTheme theme) {
    return Container(
      margin: .only(bottom: 12.h),
      padding: .symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.grey.shade200,
          value: selectedVehicle,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, size: 22.sp),
          items: vehicles.map((vehicle) {
            return DropdownMenuItem(
              value: vehicle,
              child: Row(
                children: [
                  Icon(Icons.directions_car, size: 18.sp),
                  10.width,
                  Text(vehicle, style: theme.bodyLarge),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedVehicle = value!);
          },
        ),
      ),
    );
  }

  Widget _dateTile({
    required String title,
    required DateTime date,
    required VoidCallback onTap,
    required TextTheme theme,
  }) {
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
                  '${date.day}/${date.month}/${date.year}',
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
}
