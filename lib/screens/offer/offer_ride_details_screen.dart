import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/services/google_service.dart';
import 'package:runaar/core/utils/controllers/offer/offer_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/offer_ride/load_offer_data.dart';
import 'package:runaar/provider/offerProvider/offer_provider.dart';
import 'package:runaar/screens/home/bottom_nav.dart';

class OfferRideDetailsScreen extends StatefulWidget {
  const OfferRideDetailsScreen({super.key});

  @override
  State<OfferRideDetailsScreen> createState() => _OfferRideDetailsScreenState();
}

class _OfferRideDetailsScreenState extends State<OfferRideDetailsScreen> {
  bool luggageAllowed = true;
  bool petsAllowed = false;
  bool smokingAllowed = false;

  String duration = "";
  String distance = "";

  Future<void> _calculateDistance(
    double originLat,
    double originLong,
    double destLat,
    double destLong,
  ) async {
    final time = await googlePlacesService.getDistanceAndTime(
      picLat: originLat,
      piclng: originLong,
      dropLat: destLat,
      droplng: destLong,
    );
    setState(() {
      duration = time['formatted_time'];
      distance = time['distance_km'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final offerProvider = context.read<OfferProvider>();
    final data = offerProvider.data;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _calculateDistance(
        double.parse(data?.originLat ?? ""),
        double.parse(data?.originLong ?? ""),
        double.parse(data?.destinationLat ?? ""),
        double.parse(data?.destinationLong ?? ""),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          height: 56.h,
          child: ElevatedButton(
            onPressed: () => _publish(offerProvider),
            child: offerProvider.isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.publish, size: 20.sp),
                      8.width,
                      const Text('PUBLISH RIDE'),
                    ],
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _routeCard(theme, data),
            16.height,
            Text('Add ride preferences', style: theme.titleMedium),
            8.height,

            _priceInput(theme),

            _sectionTitle('Allowances'),
            _switchTile(
              title: 'Luggage allowed',
              value: luggageAllowed,
              icon: Icons.luggage,
              onChanged: (v) => setState(() => luggageAllowed = v),
              theme: theme,
            ),
            _switchTile(
              title: 'Pets allowed',
              value: petsAllowed,
              icon: Icons.pets,
              onChanged: (v) => setState(() => petsAllowed = v),
              theme: theme,
            ),

            _sectionTitle('Preferences'),
            _switchTile(
              title: 'Smoking allowed',
              value: smokingAllowed,
              icon: Icons.smoking_rooms,
              onChanged: (v) => setState(() => smokingAllowed = v),
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeCard(TextTheme theme, LoadOfferData? data) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timeLine(theme, data),
            14.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationBlock(
                    time: data?.deptTime ?? "",
                    city: data?.originCity ?? "",
                    address: data?.originAddress ?? "",
                    theme: theme,
                  ),
                  18.height,
                  _locationBlock(
                    time: data?.arrivalTime ?? "",
                    city: data?.destinationCity ?? "",
                    address: data?.destinationAddress ?? "",
                    theme: theme,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeLine(TextTheme theme, LoadOfferData? data) {
    return Column(
      children: [
        Text(data?.deptTime ?? "", style: theme.bodyMedium),
        Container(
          height: 18.h,
          width: 2.w,
          margin: 6.all,
          color: appColor.mainColor,
        ),
        Text(duration, style: theme.bodySmall),
        Container(
          height: 18.h,
          width: 2.w,
          margin: 6.all,
          color: appColor.mainColor,
        ),
        Text(data?.arrivalTime ?? "", style: theme.bodyMedium),
      ],
    );
  }

  Widget _locationBlock({
    required String time,
    required String city,
    required String address,
    required TextTheme theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 18.sp, color: appColor.mainColor),
            6.width,
            Text(
              city,
              style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        4.height,
        Text(address, style: theme.bodySmall, maxLines: 2),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
      ),
    );
  }

  Widget _priceInput(TextTheme theme) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          TextField(
            controller: offerController.priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.currency_rupee, color: appColor.mainColor),
              hintText: 'Enter Price/seat',
              hintStyle: theme.bodyMedium,
            ),
          ),
          _seatSelector(theme),
        ],
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
    required TextTheme theme,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      // padding: 14.all,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: appColor.mainColor),
          12.width,
          Expanded(child: Text(title, style: theme.bodyLarge)),
          Switch(
            value: value,
            activeColor: appColor.mainColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _seatSelector(TextTheme theme) {
    return Consumer<OfferProvider>(
      builder: (BuildContext context, provider, child) {
        return Container(
          padding: 14.hv(16),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Number of Seats', style: theme.titleSmall),
              Row(
                children: [
                  _seatButton(Icons.remove, () {
                    provider.decrement();
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text('${provider.seats}', style: theme.titleMedium),
                  ),
                  _seatButton(Icons.add, () {
                    provider.increment();
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _seatButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(20.r),
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: appColor.backgroundColor,
        child: Icon(icon, color: appColor.mainColor, size: 18.sp),
      ),
    );
  }

  Future<void> _publish(OfferProvider provider) async {
    final data = provider.data;

    if (offerController.priceController.text.isEmpty) {
      appSnackbar.showSingleSnackbar(context, "Please Enter price for Seats");
      return;
    }
    await provider.tripPublish(
      userId: data?.userId ?? 0,
      originLat: data?.originLat ?? "",
      originLong: data?.originLong ?? "",
      originAddress: data?.originAddress ?? "",
      originCity: data?.originCity ?? "",
      destinationLat: data?.destinationLat ?? "",
      destinationLong: data?.destinationLong ?? "",
      destinationAddress: data?.destinationAddress ?? "",
      destinationCity: data?.destinationCity ?? "",
      deptDate: data?.deptDate ?? "",
      arrivalDate: data?.arrivalDate ?? "",
      deptTime: data?.deptTime ?? "",
      arrivalTime: data?.arrivalTime ?? "",
      vehicleId: data?.vehicleId ?? 0,
      price: offerController.priceController.text,
      availableSeats: provider.seats,
      luggageAllowed: luggageAllowed ? 1 : 0,
      petAllowed: petsAllowed ? 1 : 0,
      smokingAllowed: smokingAllowed ? 1 : 0,
    );
    if (provider.errorMessage != null) {
      appSnackbar.showSingleSnackbar(context, provider.errorMessage ?? "");
      return;
    }
    appSnackbar.showSingleSnackbar(context, provider.reponse?.message ?? "");
    if (!mounted) return;
    appNavigator.pushAndRemoveUntil(BottomNav(initialIndex: 1, rideIndex: 1));
  }
}
