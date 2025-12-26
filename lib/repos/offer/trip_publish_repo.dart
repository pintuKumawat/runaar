import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/offer/trip_publish_model.dart';

class TripPublishRepo {
  Future<TripPublishModel> tripPublish({
    required int userId,
    required String originLat,
    required String originLong,
    required String originAddress,
    required String originCity,
    required String destinationLat,
    required String destinationLong,
    required String destinationAddress,
    required String destinationCity,
    required String deptDate,
    required String arrivalDate,
    required String deptTime,
    required String arrivalTime,
    required int vehicleId,
    required String price,
    required int availableSeats,
    required int luggageAllowed,
    required int petAllowed,
    required int smokingAllowed,
  }) async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "origin_lat": originLat,
      "origin_long": originLong,
      "origin_address": originAddress,
      "origin_city": originCity,
      "destination_lat": destinationLat,
      "destination_long": destinationLong,
      "destination_address": destinationAddress,
      "destination_city": destinationCity,
      "dept_date": deptDate,
      "arrival_date": arrivalDate,
      "selected_vehicle_id": vehicleId,
      "price_per_seat": price,
      "available_seats": availableSeats,
      "luggage_allowed": luggageAllowed,
      "pet_allowed": petAllowed,
      "smoking_allowed": smokingAllowed,
      "dept_time": deptTime,
      "arrival_time": arrivalTime,
    };

    return apiMethods.post(
      endpoint: "trip/publish",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return TripPublishModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final TripPublishRepo tripPublishRepo = TripPublishRepo();


// {
//     "user_id": 1,
//     "origin_lat": 28.7041,
//     "origin_long": 77.1025,
//     "origin_address": "Connaught Place, Delhi",
//     "origin_city": "Delhi",
//     "dept_time": "08:30",
//     "arrival_time": "14:00",
//     "destination_lat": 27.1767,
//     "destination_long": 78.0081,
//     "destination_address": "Taj Mahal, Agra",
//     "destination_city": "Agra",
//     "dept_date": "2024-12-15",
//     "arrival_date": "2024-12-15",
//     "selected_vehicle_id": 5,
//     "price_per_seat": 350,
//     "available_seats": 4,
//     "remaning_seats": 4,
//     "luggage_allowed": 0,
//     "pet_allowed": 1,
//     "smoking_allowed": 0
// }