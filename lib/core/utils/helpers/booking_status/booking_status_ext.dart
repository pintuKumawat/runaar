import 'package:flutter/material.dart';

enum BookingStatus { confirmed, rejected, cancelled, completed, pending }

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.confirmed:
        return "Confirmed";
      case BookingStatus.rejected:
        return "Rejected";
      case BookingStatus.cancelled:
        return "Cancelled";
      case BookingStatus.completed:
        return "Completed";
      case BookingStatus.pending:
        return "Pending";
    }
  }

  Color get backgroundColor {
    switch (this) {
      case BookingStatus.confirmed:
        return Colors.blue.shade100;
      case BookingStatus.completed:
        return Colors.green.shade100;
      case BookingStatus.pending:
        return Colors.orange.shade100;
      case BookingStatus.rejected:
        return Colors.red.shade100;
      case BookingStatus.cancelled:
        return Colors.grey.shade300;
    }
  }

  Color get textColor {
    switch (this) {
      case BookingStatus.confirmed:
        return Colors.blue.shade800;
      case BookingStatus.completed:
        return Colors.green.shade800;
      case BookingStatus.pending:
        return Colors.orange.shade800;
      case BookingStatus.rejected:
        return Colors.red.shade800;
      case BookingStatus.cancelled:
        return Colors.grey.shade700;
    }
  }
}
