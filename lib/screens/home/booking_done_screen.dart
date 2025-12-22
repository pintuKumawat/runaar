import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class BookingDoneScreen extends StatefulWidget {
  const BookingDoneScreen({super.key});

  @override
  State<BookingDoneScreen> createState() => _BookingDoneScreenState();
}

class _BookingDoneScreenState extends State<BookingDoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
      ),
     body: Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check_circle, size: 120, color: Colors.green),
      16.height,
      Text(
        'Your booking has been successfully completed!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ],
  ),
),

    );
  }
}