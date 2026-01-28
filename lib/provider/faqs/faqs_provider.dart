import 'package:flutter/material.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/faqs/faqs_model.dart';
import 'package:runaar/repos/faqs/faqs_repo.dart';

class FaqsProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = false;
  FaqsModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  FaqsModel? get response => _response;

  Future<void> getFaqs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await faqsRepo.faqs();
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
