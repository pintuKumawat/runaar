
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CustomPlaceResult {
  final String description;
  final double latitude;
  final double longitude;

  CustomPlaceResult({
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}

class GooglePlacesService {
  static final _places = FlutterGooglePlacesSdk(
    'AIzaSyBY2WMBsS7J0A-5rxJb5hGgxzYRWniC-eE',
  );

  /// 🔹 Get autocomplete predictions
  static Future<List<AutocompletePrediction>> getPredictions(
    String query,
  ) async {
    if (query.isEmpty) return [];
    final result = await _places.findAutocompletePredictions(query);
    return result.predictions;
  }

  /// 🔹 Get place details by placeId
  static Future<Place?> getPlaceDetails(String placeId) async {
    final result = await _places.fetchPlace(
      placeId,
      fields: [
        PlaceField.Location,
        PlaceField.AddressComponents,
        PlaceField.Name,
      ],
    );
    return result.place;
  }

  /// 🔹 Get address from latitude & longitude
  static Future<CustomPlaceResult> getPlaceFromLatLng(
    double lat,
    double lng,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      final place = placemarks.first;

      final address = [
        place.name,
        place.street,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      return CustomPlaceResult(
        description: address,
        latitude: lat,
        longitude: lng,
      );
    } catch (e) {
      return CustomPlaceResult(
        description: 'Lat: $lat, Lng: $lng',
        latitude: lat,
        longitude: lng,
      );
    }
  }

  /// 🔹 Get distance (in km) and estimated time (in minutes)
  static Future<Map<String, dynamic>> getDistanceAndTime({
    required double picLat,
    required double piclng,
    required double dropLat,
    required double droplng,
    double averageSpeedKmh = 60, // default average driving speed
  }) async {
    try {
      final distanceInMeters = Geolocator.distanceBetween(
        picLat,
        piclng,
        dropLat,
        droplng,
      );
      final distanceInKm = distanceInMeters / 1000;

      final timeInHours = distanceInKm / averageSpeedKmh;
      final totalMinutes = (timeInHours * 60).round();

      // 🔹 Convert minutes → days, hours, minutes
      final days = totalMinutes ~/ (24 * 60);
      final hours = (totalMinutes % (24 * 60)) ~/ 60;
      final minutes = totalMinutes % 60;

      // 🔹 Build a smart formatted time string
      String formattedTime = '';
      if (days > 0) formattedTime += '$days d ';
      if (hours > 0) formattedTime += '$hours hr ';
      if (minutes > 0 || formattedTime.isEmpty) formattedTime += '$minutes min';

      return {
        'distance_km': double.parse(distanceInKm.toStringAsFixed(2)),
        'formatted_time': formattedTime.trim(),
      };
    } catch (e) {
      print('Error calculating distance/time: $e');
      return {'distance_km': 0.0, 'time_min': 0.0, 'formatted_time': '0 min'};
    }
  }
}
