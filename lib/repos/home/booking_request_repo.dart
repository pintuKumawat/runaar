import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/home/booking_request_model.dart';

class BookingRequestRepo {
  Future<BookingRequestModel> bookingRequest({
    required int trip_id,
    required int user_id,
    required int seat_request,
    required double total_price,
    required String payment_method,
    required String payment_status,
    required String special_message,
  }) async {
    Map<String, dynamic> body = {
      "trip_id": trip_id,
      "user_id": user_id,
      "seats_requested": seat_request,
      "total_price": total_price,
      "payment_method": payment_method,
      "payment_status": payment_status,
      "spical_message": special_message,
    };
    return apiMethods.post(
      endpoint: "booking/request",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return BookingRequestModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final BookingRequestRepo bookingRequestRepo = BookingRequestRepo();
