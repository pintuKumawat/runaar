import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/home/home_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/core/utils/helpers/location_picker_sheet/location_picker_bottom.dart';
import 'package:runaar/l10n/app_localizations.dart';
import 'package:runaar/provider/home/home_provider.dart';
import 'package:runaar/screens/home/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime departureDate = DateTime.now();
  int seats = 1;

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

    setState(() {
      departureDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
   final lan=AppLocalizations.of(context)!;
    final theme = Theme.of(context).textTheme;
    final homeProvider = context.read<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('CARPOOL'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              Icon(Icons.notifications, size: 26.sp),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 7.r,
                  backgroundColor: Colors.red,
                  child: Text(
                    '11',
                    style: theme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lan.findRide, style: theme.titleMedium,),
            16.height,

            _inputTile(
              icon: Icons.my_location,
              hint: lan.enterPickupLocation,
              theme: theme,
              controller: homeController.originController,
              type: 'pickup',
            ),
            _inputTile(
              icon: Icons.location_on,
              hint: lan.enterDropLocation,
              theme: theme,
              controller: homeController.destinationController,
              type: 'drop',
            ),

            _seatSelector(theme),

            14.height,

            GestureDetector(
              onTap: _pickDepartureDate,
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
                        Text('Date of Departure', style: theme.bodySmall),
                        4.height,
                        Text(
                          '${departureDate.day}/${departureDate.month}/${departureDate.year}',
                          style: theme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.calendar_month, size: 22.sp),
                  ],
                ),
              ),
            ),

            26.height,

            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _searchButton,
                child: homeProvider.isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.search, size: 22.sp),
                          4.width,
                          Text('SEARCH RIDE'),
                        ],
                      ),
              ),
            ),

            30.height,
          ],
        ),
      ),
    );
  }

  Future<void> _searchButton() async {
    final homeProvider = context.read<HomeProvider>();
    String date =
        '${departureDate.year}-${departureDate.month}-${departureDate.day}';

    await homeProvider.rideSearch(
      // deptDate: date,
      // originCity: homeController.originCityController.text,
      // destinationCity: homeController.destinationCityController.text,
      deptDate: "2024-12-20",
      originCity: "Delhi",
      destinationCity: "Jaipur",
    );

    appNavigator.push(SearchScreen());
  }

  Widget _seatSelector(TextTheme theme) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Container(
          padding: 14.hv(16),
          margin: .only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Number of Seats', style: theme.bodyLarge),
              Row(
                children: [
                  _seatButton(Icons.remove, () {
                    homeProvider.decrement();
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text(
                      "${homeProvider.seats}",
                      style: theme.titleMedium,
                    ),
                  ),
                  _seatButton(Icons.add, () {
                    homeProvider.increment();
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

  Future<void> openLocationPicker(String type) async {
    final result = await showModalBottomSheet<AutocompletePrediction>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      builder: (_) =>
          LocationPickerBottomSheet(type: type, screenType: "search"),
    );

    if (result != null) {
      // Update text fields when user selects location
      if (type == 'pickup') {
        homeController.originController.text = result.fullText;
      } else {
        homeController.destinationController.text = result.fullText;
      }
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
}
