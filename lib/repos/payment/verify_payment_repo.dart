import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/payment/verify_payment_model.dart';

class VerifyPaymentRepo {
  Future<VerifyPaymentModel> verifyPayment({
    required String razorpayOrderId,
    required String razorpaySignature,
    required String razorpayPaymentId,
  }) async {
    Map<String, dynamic> body = {
      "razorpay_order_id": razorpayOrderId,
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_signature": razorpaySignature,
    };
    return apiMethods.post(
      endpoint: "payment/verify-payment",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return VerifyPaymentModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

final VerifyPaymentRepo verifyPaymentRepo = VerifyPaymentRepo();
