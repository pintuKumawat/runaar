import 'package:flutter/material.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/home/bottom_nav.dart';

class BookingDoneScreen extends StatefulWidget {
  final String paymentMethod;
  const BookingDoneScreen({super.key, required this.paymentMethod});

  @override
  State<BookingDoneScreen> createState() => _BookingDoneScreenState();
}

class _BookingDoneScreenState extends State<BookingDoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmed')),
      bottomNavigationBar: _bottomButton(),
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

  Widget _bottomButton() {
    return BottomAppBar(
      child: SizedBox(
        height: 56.h,
        width: .infinity,
        child: ElevatedButton(
          onPressed: () => appNavigator.pushAndRemoveUntil(
            const BottomNav(initialIndex: 1, rideIndex: 0),
          ),
          child: Text("Done"),
        ),
      ),
    );
  }
}
