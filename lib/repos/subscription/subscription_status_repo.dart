import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/subscription/subscription_status_model.dart';

class SubscriptionStatusRepo {
  Future<SubscriptionStatusModel> subscriptionStatus({
    required String razorpayOrderId,
    required int userid,
  }) async {
    Map<String, dynamic> body = {
      "razorpay_order_id": razorpayOrderId,
      "user_id": userid,
    };

    return apiMethods.post(
      endpoint: "subscription_payment/status",
      body: body,
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return SubscriptionStatusModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

SubscriptionStatusRepo subscriptionStatusRepo = SubscriptionStatusRepo();
