import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/home/booking_request_model.dart';

class BookingRequestRepo {
  Future<BookingRequestModel> bookingRequest({
    required int tripId,
    required int userId,
    required int seatRequest,
    required double totalPrice,
    required String paymentMethod,
    required String paymentStatus,
    required String specialMessage,
  }) async {
    Map<String, dynamic> body = {
      "trip_id": tripId,
      "user_id": userId,
      "seats_requested": seatRequest,
      "total_price": totalPrice,
      "payment_method": paymentMethod,
      "payment_status": paymentStatus,
      "special_message": specialMessage,
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
