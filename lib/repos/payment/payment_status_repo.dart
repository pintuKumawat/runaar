import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/payment/payment_status_model.dart';

class PaymentStatusRepo {
  Future<PaymentStatusModel> paymentStatus({required int tripId}) async {
    Map<String, dynamic> body = {"trip_id": tripId};
    return apiMethods.post(
      endpoint: "payment/status",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return PaymentStatusModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final PaymentStatusRepo paymentStatusRepo = PaymentStatusRepo();
