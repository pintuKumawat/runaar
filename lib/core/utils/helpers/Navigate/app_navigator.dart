import 'package:flutter/material.dart';

class AppNavigator {
  final GlobalKey<NavigatorState> navigateKey = GlobalKey<NavigatorState>();

  Future<dynamic>? push(Widget page) {
    return navigateKey.currentState?.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic>? pushReplacement(Widget page) {
    return navigateKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<dynamic>? pushAndRemoveUntil(Widget page) {
    return navigateKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void pop([dynamic result]) {
    navigateKey.currentState?.pop(result);
  }
}

// ✅ Create one shared instance to use everywhere
final AppNavigator appNavigator = AppNavigator();
