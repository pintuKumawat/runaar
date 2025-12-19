import 'package:flutter/material.dart';

class AppSnackbar {
  bool _snackbarActive = false;

  void showSingleSnackbar(
    BuildContext context,
    String msg, {
    int durationMs = 1500,
  }) {
    if (_snackbarActive) return;
    _snackbarActive = true;
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: durationMs),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((_) {
      _snackbarActive = false;
    });
  }
}

final AppSnackbar appSnackbar = AppSnackbar();
