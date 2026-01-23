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
import 'package:runaar/screens/subscription/subscription_screen.dart';

class OfferRideDetailsScreen extends StatefulWidget {
  const OfferRideDetailsScreen({super.key});

  @override
  State<OfferRideDetailsScreen> createState() => _OfferRideDetailsScreenState();
}

class _OfferRideDetailsScreenState extends State<OfferRideDetailsScreen> {
  bool luggageAllowed = false;
  bool petsAllowed = false;
  bool smokingAllowed = false;

  String duration = "";
  String distance = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateDistance());
  }

  Future<void> _calculateDistance() async {
    final offerProvider = context.read<OfferProvider>();
    final data = offerProvider.data;

    if (data?.originLat != null &&
        data?.originLong != null &&
        data?.destinationLat != null &&
        data?.destinationLong != null) {
      try {
        final time = await googlePlacesService.getDistanceAndTime(
          picLat: double.parse(data!.originLat),
          piclng: double.parse(data.originLong),
          dropLat: double.parse(data.destinationLat),
          droplng: double.parse(data.destinationLong),
        );
        setState(() {
          duration = time['formatted_time'] ?? "";
          distance = time['distance_km']?.toString() ?? "";
        });
      } catch (e) {
        debugPrint("Error calculating distance: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      bottomNavigationBar: Consumer<OfferProvider>(
        builder: (context, provider, child) {
          return BottomAppBar(
            child: SizedBox(
              width: double.infinity,
              height: 40.h,
              child: ElevatedButton(
                onPressed: () async {
                  final agree = await _showPublishInfoDialog();
                  if (agree == true) {
                    _publish(provider);
                  }
                },

                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
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
          );
        },
      ),
      body: Consumer<OfferProvider>(
        builder: (context, provider, child) {
          final data = provider.data;
          return SingleChildScrollView(
            padding: 10.all,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _routeCard(theme, data),
                16.height,
                Text('Add ride preferences', style: theme.titleMedium),
                8.height,
                _priceInput(theme, provider),
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
          );
        },
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
        Text(formatTime(data?.deptTime ?? ""), style: theme.bodyMedium),
        Container(
          height: 18.h,
          width: 2.w,
          margin: 6.all,
          color: appColor.mainColor,
        ),
        Text(
          duration.isNotEmpty ? duration : "Calculating...",
          style: theme.bodySmall?.copyWith(color: Colors.grey),
        ),
        Container(
          height: 18.h,
          width: 2.w,
          margin: 6.all,
          color: appColor.mainColor,
        ),
        Text(formatTime(data?.arrivalTime ?? ""), style: theme.bodyMedium),
      ],
    );
  }

  String formatTime(String time) {
    if (time.isEmpty) return "";
    try {
      if (time.length >= 5) {
        final parts = time.split(':');
        if (parts.length >= 2) {
          int hour = int.tryParse(parts[0]) ?? 0;
          int minute = int.tryParse(parts[1]) ?? 0;

          String period = hour >= 12 ? 'PM' : 'AM';
          int hour12 = hour % 12;
          if (hour12 == 0) hour12 = 12;
          String minuteStr = minute.toString().padLeft(2, '0');

          return '$hour12:$minuteStr $period';
        }
      }
      return time;
    } catch (e) {
      return time;
    }
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
            Expanded(
              child: Text(
                city,
                style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        4.height,
        Text(
          address,
          style: theme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _priceInput(TextTheme theme, OfferProvider provider) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: offerController.priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.currency_rupee, color: appColor.mainColor),
              hintText: 'Enter Price/seat',
              hintStyle: theme.bodyMedium?.copyWith(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: appColor.mainColor),
              ),
            ),
          ),
          16.height,
          _seatSelector(theme, provider),
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
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: appColor.mainColor, size: 22.sp),
            12.width,
            Expanded(
              child: Text(
                title,
                style: theme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Switch(
              value: value,
              activeColor: appColor.mainColor,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _seatSelector(TextTheme theme, OfferProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Number of Seats', style: theme.bodyMedium),
          Row(
            children: [
              _seatButton(
                Icons.remove,
                () => provider.decrement(),
                provider.seats > 1, // Only enable if > 1 seat
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  '${provider.seats}',
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              _seatButton(
                Icons.add,
                () => provider.increment(),
                true, // Always enabled
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seatButton(IconData icon, VoidCallback onTap, bool enabled) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(20.r),
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: enabled
            ? appColor.mainColor.withOpacity(0.1)
            : Colors.grey.shade200,
        child: Icon(
          icon,
          color: enabled ? appColor.mainColor : Colors.grey,
          size: 18.sp,
        ),
      ),
    );
  }

  Future<void> _publish(OfferProvider provider) async {
    final data = provider.data;

    if (offerController.priceController.text.isEmpty) {
      appSnackbar.showSingleSnackbar(context, "Please enter price for seats");
      return;
    }

    final price = offerController.priceController.text;
    if (int.tryParse(price) == null) {
      appSnackbar.showSingleSnackbar(context, "Please enter a valid price");
      return;
    }

    if (int.parse(price) <= 0) {
      appSnackbar.showSingleSnackbar(context, "Price must be greater than 0");
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
      price: price,
      availableSeats: provider.seats,
      luggageAllowed: luggageAllowed ? 1 : 0,
      petAllowed: petsAllowed ? 1 : 0,
      smokingAllowed: smokingAllowed ? 1 : 0,
    );

    if (provider.errorMessage != null) {
      if (provider.errorMessage!.contains('subscription')) {
        appSnackbar.showSingleSnackbar(context, provider.errorMessage ?? "");
        return appNavigator.push(SubscriptionScreen(userId: data?.userId ?? 0));
      }
      return appSnackbar.showSingleSnackbar(
        context,
        provider.errorMessage ?? "",
      );
    }

    if (provider.reponse?.message != null) {
      appSnackbar.showSingleSnackbar(context, provider.reponse!.message!);

      setState(() {
        luggageAllowed = false;
        petsAllowed = false;
        smokingAllowed = false;
      });

      if (!mounted) return;
      appNavigator.pushAndRemoveUntil(BottomNav(initialIndex: 1, rideIndex: 1));

      provider.clearDetail();
      provider.resetSeat();
      offerController.clear();
    }
  }

  Future<bool?> _showPublishInfoDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context).textTheme;

        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: .circular(12.r)),
          title: Text(
            "Please Read Before Publishing",
            style: theme.titleMedium,
          ),
          content: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                "• You can cancel your ride until 1 hour before the departure time.",
                style: theme.bodySmall,
              ),
              8.height,
              Text(
                "• After the last 1 hour window, cancellation is not allowed.",
                style: theme.bodySmall,
              ),
              8.height,
              Text(
                "• If you cancel during the allowed period, we will deduct some reward/cash points as a penalty.",
                style: theme.bodySmall,
              ),
              12.height,
              Text(
                "Do you still want to publish the ride?",
                style: theme.bodyMedium?.copyWith(fontWeight: .w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => appNavigator.pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => appNavigator.pop(true),
              child: const Text("Agree & Publish"),
            ),
          ],
        );
      },
    );
  }
}
