import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/screens/home/booking_done_screen.dart';

class ConfirmBookingScreen extends StatefulWidget {
  const ConfirmBookingScreen({super.key});

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  String _selectedPaymentMethod = 'Cash'; // Default payment method
  final List<String> _paymentMethods = ['Cash', 'Online'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Booking details'),
      ),
      bottomNavigationBar: _bottomButton(),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Text(
              'Check your booking request details',
              style: theme.titleMedium,
              overflow: .ellipsis,
            ),
            12.height,

            _infoMessage(theme),

            20.height,

            /// DATE
            Text('Mon, 22 Dec', style: theme.titleMedium),
            10.height,

            /// ROUTE
            _routeSection(theme),

            24.height,

            /// PRICE SUMMARY
            _priceSummary(theme),

            24.height,

            /// PAYMENT METHOD
            _paymentMethodSection(theme),

            24.height,

            /// MESSAGE SECTION
            Text(
              'Send a message to Nihit to introduce yourself',
              style: theme.titleMedium,
            ),
            10.height,
            _messageBox(theme),
          ],
        ),
      ),
    );
  }

  // ------------------- Widgets -------------------

  Widget _infoMessage(TextTheme theme) {
    return Container(
      padding: 12.all,
      decoration: BoxDecoration(
        color: appColor.mainColor.withOpacity(.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: appColor.mainColor),
          10.width,
          Expanded(
            child: Text(
              "Your booking won't be confirmed until the driver approves your request",
              style: theme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _routeSection(TextTheme theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TIMELINE
        Column(children: [30.height, _dot(), _line(), _dot()]),
        14.width,

        /// LOCATIONS
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationTile(
                time: '16:30',
                title: 'Jaipur Junction',
                subtitle: 'Railway Station Rd, Gopalbari, Rajasthan',
                theme: theme,
              ),
              20.height,
              _locationTile(
                time: '17:20',
                title: 'Ringas Junction',
                subtitle: 'Reengus',
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _locationTile({
    required String time,
    required String title,
    required String subtitle,
    required TextTheme theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(time, style: theme.bodySmall?.copyWith(color: Colors.grey)),
        4.height,
        Text(
          title,
          style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        2.height,
        Text(
          subtitle,
          style: theme.bodySmall,
          overflow: .ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _priceSummary(TextTheme theme) {
    return Card(
      child: Padding(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text('Price summary', style: theme.titleMedium),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Price/Seats"),
                Text(
                  "190",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text("Seats Booking"),
                Text(
                  "2",
                  style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            8.height,
            const Divider(),
            8.height,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹380",
                  style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: appColor.mainColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodSection(TextTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method', style: theme.titleMedium),
        10.height,
        Container(
          padding: .symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<String>(
            value: _selectedPaymentMethod,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: appColor.mainColor),
            dropdownColor: Colors.white,
            items: _paymentMethods.map((String method) {
              return DropdownMenuItem<String>(
                value: method,
                child: Text(method, style: theme.bodyMedium),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              }
            },
          ),
        ),

        // Optional: Show additional info based on payment method
        10.height,
        if (_selectedPaymentMethod == 'Online')
          Container(
            padding: 12.all,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                8.width,
                Text(
                  'Payment will be processed securely',
                  style: theme.bodySmall?.copyWith(
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),

        if (_selectedPaymentMethod == 'Cash')
          Container(
            padding: 12.all,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: .circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 16),
                8.width,
                Text(
                  'Pay directly to the driver after the ride',
                  style: theme.bodySmall?.copyWith(color: Colors.blue.shade800),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _messageBox(TextTheme theme) {
    return Container(
      padding: 12.all,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: .circular(12),
      ),
      child: TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText:
              "Hello, I've just booked your ride! I'd be glad to travel with you.",
          hintStyle: theme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _bottomButton() {
    return BottomAppBar(
      child: SizedBox(
        height: 56.h,
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            appNavigator.push(
              BookingDoneScreen(),
              // BookingDoneScreen(paymentMethod: _selectedPaymentMethod),
            );
          },
          icon: const Icon(Icons.event_seat),
          label: const Text('Request to book'),
        ),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: appColor.mainColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 70.h,
      width: 2.w,
      color: appColor.mainColor.withOpacity(.6),
    );
  }
}
