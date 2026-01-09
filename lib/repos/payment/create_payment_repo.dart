import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/payment/create_payment_model.dart';

class CreatePaymentRepo {
  Future<CreatePaymentModel> createPayment({
    required int userId,
    required int tripId,
    required int amount,
  }) async {
    Map<String, dynamic> body = {
      "user_id": userId,
      "trip_id": tripId,
      "amount": amount,
    };
    return apiMethods.post(
      endpoint: "payment/create-order",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return CreatePaymentModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final CreatePaymentRepo createPaymentRepo = CreatePaymentRepo();
