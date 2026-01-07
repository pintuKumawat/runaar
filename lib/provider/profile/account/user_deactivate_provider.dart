import 'package:flutter/foundation.dart';
import 'package:runaar/core/services/api_response.dart';
import 'package:runaar/models/profile/account/user_deactivate_model.dart';
import 'package:runaar/repos/profile/account/user_deactivate_repo.dart';

class UserDeactivateProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _isLoading = true;
  UserDeactivateModel? _response;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  UserDeactivateModel? get response => _response;

  Future<void> userDeactivate({required int userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await userDeactivateRepo.userDeactivate(userId: userId);
      _response = result;
    } on ApiException catch (e) {
      _errorMessage = e.message;

      debugPrint("API Exception: $_errorMessage");
    } catch (e) {
      _errorMessage = "Unexpected error :$_errorMessage";
      debugPrint("❌ Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
