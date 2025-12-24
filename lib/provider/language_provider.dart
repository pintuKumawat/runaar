import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {

   Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  LanguageProvider() {
    fetchLocale();
  }

  Future<void> fetchLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('language_code');
    if (code == null || code.isEmpty) {
      _appLocale = const Locale('en');
    } else {
      _appLocale = Locale(code);
    }
    notifyListeners();
  }

  Future<void> changeLanguage(Locale locale) async {
    _appLocale = locale;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
}