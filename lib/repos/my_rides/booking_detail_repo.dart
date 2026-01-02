import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/booking_detail_model.dart';

class BookingDetailRepo {
  Future<BookingDetailModel> bookingDetail({required int tripId}) async {
    Map<String, dynamic> body = {"booking_id": tripId};
    return apiMethods.post(
      endpoint: "booking/booking_detail",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return BookingDetailModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final BookingDetailRepo bookingDetailRepo = BookingDetailRepo();
