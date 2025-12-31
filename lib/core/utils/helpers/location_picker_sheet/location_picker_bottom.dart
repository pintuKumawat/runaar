// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:runaar/core/services/google_service.dart';
// import 'package:runaar/core/utils/controllers/home/home_controller.dart';
// import 'package:runaar/core/utils/controllers/offer/offer_controller.dart';
// import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
// import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

// class LocationPickerBottomSheet extends StatefulWidget {
//   final String type;
//   final String screenType;
//   final String? initialValue;

//   const LocationPickerBottomSheet({
//     super.key,
//     required this.type,
//     required this.screenType,
//     this.initialValue,
//   });

//   @override
//   State<LocationPickerBottomSheet> createState() =>
//       _LocationPickerBottomSheetState();
// }

// class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
//   final TextEditingController searchController = TextEditingController();
//   List<AutocompletePrediction> suggestions = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
//       searchController.text = widget.initialValue!;
//       _onTextChanged(widget.initialValue!);
//     }
//   }

//   /// 🔍 Handle search typing
//   Future<void> _onTextChanged(String value) async {
//     if (value.isEmpty) {
//       setState(() => suggestions = []);
//       return;
//     }

//     setState(() => isLoading = true);
//     final result = await googlePlacesService.getPredictions(value);
//     if (mounted) {
//       setState(() {
//         suggestions = result;
//         isLoading = false;
//       });
//     }
//   }

//   /// 📍 Use current location
//   Future<void> _useCurrentLocation() async {
//     if (isLoading) return;
//     if (!mounted) return;

//     setState(() => isLoading = true);

//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         if (mounted) {
// appSnackbar.showSingleSnackbar(
//   context,
//   'Please enable location services',
// );
//         }
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           if (mounted) {
// appSnackbar.showSingleSnackbar(
//   context,
//   'Location permission denied',
// );
//           }
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         if (mounted) {
// appSnackbar.showSingleSnackbar(
//   context,
//   'Permission permanently denied, enable in settings',
// );
//         }
//         return;
//       }

//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );

//       final customPlace = await googlePlacesService.getPlaceFromLatLng(
//         position.latitude,
//         position.longitude,
//       );

//       final prediction = AutocompletePrediction(
//         placeId: 'current_location',
//         primaryText: customPlace.description,
//         secondaryText: 'Current Location',
//         fullText: customPlace.description,
//         distanceMeters: 0,
//       );

//       if (!mounted) return;

//       // IMPORTANT: disable loading before pop
//       setState(() => isLoading = false);

//       appNavigator.pop(prediction);

//       return;
//     } catch (e) {
//       if (mounted) {
//         appSnackbar.showSingleSnackbar(context, 'Error getting location: $e');
//       }
//     } finally {
//       if (mounted && isLoading) setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.9,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: DraggableScrollableSheet(
//         expand: true,
//         initialChildSize: 1.0,
//         minChildSize: 0.5,
//         maxChildSize: 1.0,
//         builder: (context, scrollController) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // --- Handle bar ---
//                 Container(
//                   width: 40,
//                   height: 4,
//                   margin: const EdgeInsets.only(bottom: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[400],
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),

//                 // --- Search TextField with clear (X) icon ---
//                 TextField(
//                   controller: searchController,
//                   autofocus: true,
//                   onChanged: _onTextChanged,
//                   decoration: InputDecoration(
//                     hintText: 'Search ${widget.type} location',
//                     prefixIcon: const Icon(Icons.search),
//                     suffixIcon: searchController.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.close),
//                             onPressed: () {
//                               setState(() {
//                                 searchController.clear();
//                                 suggestions = [];
//                               });
//                             },
//                           )
//                         : null,
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 // --- Use Current Location Button ---
//                 InkWell(
//                   onTap: _useCurrentLocation,
//                   borderRadius: BorderRadius.circular(8),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 14,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8),
//                       color: Colors.blue.shade50,
//                     ),
//                     child: Row(
//                       children: const [
//                         Icon(Icons.my_location, color: Colors.blueAccent),
//                         SizedBox(width: 10),
//                         Text(
//                           'Use Current Location',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 if (isLoading)
//                   const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Center(child: CircularProgressIndicator()),
//                   ),

//                 if (!isLoading)
//                   Expanded(
//                     child: ListView.builder(
//                       controller: scrollController,
//                       itemCount: suggestions.length,
//                       itemBuilder: (context, index) {
//                         final place = suggestions[index];
//                         return ListTile(
//                           leading: const Icon(
//                             Icons.location_on,
//                             color: Colors.blueAccent,
//                           ),
//                           title: Text(place.fullText),
//                           onTap: () async {
//                             final details = await googlePlacesService
//                                 .getPlaceDetails(place.placeId);

//                             // ---- Extract values ----
//                             final fullAddress = place.fullText;
//                             final cityName = _extractCityFromAddress(
//                               fullAddress,
//                             );
//                             final lat = details?.latLng?.lat.toString() ?? "";
//                             final lng = details?.latLng?.lng.toString() ?? "";

//                             if (widget.screenType == 'offer') {
//                               if (widget.type.toLowerCase() == 'pickup') {
//                                 offerController.originController.text =
//                                     fullAddress;
//                                 offerController.originCityController.text =
//                                     cityName;
//                                 offerController.originLatController.text = lat;
//                                 offerController.originLongController.text = lng;
//                               } else {
//                                 offerController.destinationController.text =
//                                     fullAddress;
//                                 offerController.destinationCityController.text =
//                                     cityName;
//                                 offerController.destinationLatController.text =
//                                     lat;
//                                 offerController.destinationLongController.text =
//                                     lng;
//                               }
//                             }

//                             if (widget.screenType == 'search') {
//                               if (widget.type.toLowerCase() == 'pickup') {
//                                 homeController.originController.text =
//                                     fullAddress;
//                                 homeController.originCityController.text =
//                                     cityName;
//                                 homeController.originLatController.text = lat;
//                                 homeController.originLongController.text = lng;
//                               } else {
//                                 homeController.destinationController.text =
//                                     fullAddress;
//                                 homeController.destinationCityController.text =
//                                     cityName;
//                                 homeController.destinationLatController.text =
//                                     lat;
//                                 homeController.destinationLongController.text =
//                                     lng;
//                               }
//                             }

//                             FocusScope.of(context).unfocus();
//                             appNavigator.pop();
//                           },
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   String _extractCityFromAddress(String address) {
//     List<String> parts = address.split(',').map((e) => e.trim()).toList();

//     // Common Indian states/UT list — minimal set, expand if needed
//     final ignoreList = {
//       "India",
//       "Rajasthan",
//       "Maharashtra",
//       "Uttar Pradesh",
//       "Madhya Pradesh",
//       "Gujarat",
//       "Delhi",
//       "Haryana",
//       "Punjab",
//       "Karnataka",
//       "Tamil Nadu",
//       "Telangana",
//       "Kerala",
//       "Bihar",
//       "Assam",
//     };

//     for (int i = parts.length - 1; i >= 0; i--) {
//       final word = parts[i];
//       if (!ignoreList.contains(word) && word.length > 2) {
//         return word;
//       }
//     }

//     return address; // fallback
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:runaar/core/responsive/responsive_extension.dart'
    show PaddingExtensions;
import 'package:runaar/core/services/google_service.dart';
import 'package:runaar/core/theme/app_text.dart';
import 'package:runaar/core/utils/controllers/home/home_controller.dart';
import 'package:runaar/core/utils/controllers/offer/offer_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

class LocationPickerBottomSheet extends StatefulWidget {
  final String type;
  final String screenType;
  final String? initialValue;

  const LocationPickerBottomSheet({
    super.key,
    required this.type,
    required this.screenType,
    this.initialValue,
  });

  @override
  State<LocationPickerBottomSheet> createState() =>
      _LocationPickerBottomSheetState();
}

class _LocationPickerBottomSheetState extends State<LocationPickerBottomSheet> {
  final TextEditingController searchController = TextEditingController();
  List<AutocompletePrediction> suggestions = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      searchController.text = widget.initialValue!;
      _onTextChanged(widget.initialValue!);
    }
  }

  /// ---------------------------------------------------------
  /// SEARCH
  /// ---------------------------------------------------------
  Future<void> _onTextChanged(String value) async {
    if (value.isEmpty) {
      setState(() => suggestions = []);
      return;
    }

    setState(() => isLoading = true);
    final result = await googlePlacesService.getPredictions(value);
    if (!mounted) return;

    setState(() {
      suggestions = result;
      isLoading = false;
    });
  }

  /// ---------------------------------------------------------
  /// CURRENT LOCATION
  /// ---------------------------------------------------------
  Future<void> _useCurrentLocation() async {
    if (isLoading) return;
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          appSnackbar.showSingleSnackbar(
            context,
            'Please enable location services',
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            appSnackbar.showSingleSnackbar(
              context,
              'Location permission denied',
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          appSnackbar.showSingleSnackbar(
            context,
            'Permission permanently denied, enable in settings',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final customPlace = await googlePlacesService.getPlaceFromLatLng(
        position.latitude,
        position.longitude,
      );

      final prediction = AutocompletePrediction(
        placeId: 'current_location',
        primaryText: customPlace.description,
        secondaryText: 'Current Location',
        fullText: customPlace.description,
        distanceMeters: 0,
      );

      if (!mounted) return;

      setState(() => isLoading = false);

      appNavigator.pop(prediction);
      return;
    } catch (e) {
      if (mounted) {
        appSnackbar.showSingleSnackbar(context, 'Error getting location: $e');
      }
    } finally {
      if (mounted && isLoading) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextSize.getTextTheme(context);

    return Container(
      height: 0.90.sh,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        expand: true,
        initialChildSize: 1.0,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Padding(
            padding: 16.all,
            child: Column(
              children: [
                /// Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),

                /// Search field
                TextField(
                  controller: searchController,
                  autofocus: true,
                  onChanged: _onTextChanged,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Search ${widget.type} location',
                    hintStyle: textTheme.bodyMedium,
                    prefixIcon: Icon(
                      Icons.search,
                      color: appColor.textColor,
                      size: 20.sp,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 20.sp,
                              color: appColor.textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                suggestions = [];
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                /// Use current location button
                InkWell(
                  onTap: _useCurrentLocation,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.blue.shade50,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location,
                          color: Colors.blueAccent,
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Use Current Location',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                if (isLoading)
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                /// Suggestions list
                if (!isLoading)
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final place = suggestions[index];
                        return ListTile(
                          minLeadingWidth: 30.w,
                          leading: Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                            size: 22.sp,
                          ),
                          title: Text(
                            place.fullText,
                            style: textTheme.bodyMedium,
                          ),
                          onTap: () async {
                            final details = await googlePlacesService
                                .getPlaceDetails(place.placeId);

                            final fullAddress = place.fullText;
                            final cityName = _extractCityFromAddress(
                              fullAddress,
                            );
                            final lat = details?.latLng?.lat.toString() ?? "";
                            final lng = details?.latLng?.lng.toString() ?? "";

                            if (widget.screenType == 'offer') {
                              final isPickup =
                                  widget.type.toLowerCase() == 'pickup';
                              final c = offerController;

                              if (isPickup) {
                                c.originController.text = fullAddress;
                                c.originCityController.text = cityName;
                                c.originLatController.text = lat;
                                c.originLongController.text = lng;
                              } else {
                                c.destinationController.text = fullAddress;
                                c.destinationCityController.text = cityName;
                                c.destinationLatController.text = lat;
                                c.destinationLongController.text = lng;
                              }
                            }

                            if (widget.screenType == 'search') {
                              final isPickup =
                                  widget.type.toLowerCase() == 'pickup';
                              final c = homeController;

                              if (isPickup) {
                                c.originController.text = fullAddress;
                                c.originCityController.text = cityName;
                                c.originLatController.text = lat;
                                c.originLongController.text = lng;
                              } else {
                                c.destinationController.text = fullAddress;
                                c.destinationCityController.text = cityName;
                                c.destinationLatController.text = lat;
                                c.destinationLongController.text = lng;
                              }
                            }

                            FocusScope.of(context).unfocus();
                            appNavigator.pop();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Extract city from address
  String _extractCityFromAddress(String address) {
    List<String> parts = address.split(',').map((e) => e.trim()).toList();

    final ignoreList = {
      "India",
      "Rajasthan",
      "Maharashtra",
      "Uttar Pradesh",
      "Madhya Pradesh",
      "Gujarat",
      "Delhi",
      "Haryana",
      "Punjab",
      "Karnataka",
      "Tamil Nadu",
      "Telangana",
      "Kerala",
      "Bihar",
      "Assam",
    };

    for (int i = parts.length - 1; i >= 0; i--) {
      final word = parts[i];
      if (!ignoreList.contains(word) && word.length > 2) {
        return word;
      }
    }

    return address;
  }
}
