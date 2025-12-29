import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/my_rides/booking_list_model.dart';

class BookingListRepo {
  Future<BookingListModel> bookingList({required int userId}) async {
    Map<String, dynamic> body = {"user_id": userId};
    return apiMethods.post(
      endpoint: "booking/booking_list",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return BookingListModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final BookingListRepo bookingListRepo = BookingListRepo();
