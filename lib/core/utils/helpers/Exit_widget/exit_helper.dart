import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

class ExitAppHelper {
  DateTime? _lastPressTime;

  Future<void> handleExit(BuildContext context) async {
    final now = DateTime.now();

    // Double tap check
    if (_lastPressTime == null ||
        now.difference(_lastPressTime!) > const Duration(seconds: 2)) {
      _lastPressTime = now;

      appSnackbar.showSingleSnackbar(context, "Press again to exit");
      return;
    }

    if (kIsWeb) {
      Navigator.of(context).maybePop();
      return;
    }

    if (Platform.isIOS) {
      // ❌ Apple does NOT allow app exit
      appSnackbar.showSingleSnackbar(context, "Cannot exit the app on iOS");
      return;
    }

    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 120), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      return;
    }

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
      return;
    }
  }
}

final ExitAppHelper exitAppHelper = ExitAppHelper();
