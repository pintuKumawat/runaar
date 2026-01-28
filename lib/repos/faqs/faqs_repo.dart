import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/faqs/faqs_model.dart';

class FaqsRepo {
  Future<FaqsModel> faqs() async {
    return apiMethods.get(
      endpoint: "faqs",
      onSuccess: (responseData) {
        if (responseData["status"].toString().toLowerCase() == "success") {
          return FaqsModel.fromJson(responseData);
        } else {
          throw ApiException(responseData["message"]);
        }
      },
    );
  }
}

FaqsRepo faqsRepo = FaqsRepo();
