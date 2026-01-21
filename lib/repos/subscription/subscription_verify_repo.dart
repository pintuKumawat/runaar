import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_verify_model.dart';

class SubscriptionVerifyRepo {
  Future<SubscriptionVerifyModel> subscriptionVerify({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    Map<String, dynamic> body = {
      "razorpay_payment_id": razorpayPaymentId,
      "razorpay_order_id": razorpayOrderId,
      "razorpay_signature": razorpaySignature,
    };

    return apiMethods.post(
      endpoint: "subscription_payment/verify-payment",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return SubscriptionVerifyModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

SubscriptionVerifyRepo subscriptionVerifyRepo = SubscriptionVerifyRepo();
