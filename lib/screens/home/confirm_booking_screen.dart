import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Saved_data/saved_data.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/provider/home/home_provider.dart';
import 'package:runaar/provider/auth/validate/login_provider.dart';
import 'package:runaar/provider/home/booking_request_provider.dart';
import 'package:runaar/screens/home/booking_done_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final String date;
  final String originTime;
  final String originCity;
  final String originAddress;
  final String destinationTime;
  final String destinationCity;
  final String destinationAddress;
  final double seatPrice;
  final int tripId;
  const ConfirmBookingScreen({
    super.key,
    required this.date,
    required this.originTime,
    required this.originCity,
    required this.originAddress,
    required this.destinationTime,
    required this.destinationCity,
    required this.destinationAddress,
    required this.seatPrice,
    required this.tripId,
  });

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  int? userId;
  Future<void> getuserId() async {
    var prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt(savedData.userId);
    setState(() {
      userId = id ?? 0;
    });
  }
  
 
  String _selectedPaymentMethod = 'Cash';
  final List<String> _paymentMethods = ['Cash', 'Online'];

  double calculateTotalPrice() {
    try {
      final homeProvider = context.read<HomeProvider>();
      return widget.seatPrice * homeProvider.seats;
    } catch (e) {
      debugPrint("Error calculating total price: $e");
      return 0.0;
    }
  }

  // Format price to 2 decimal places
  String formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().resetSeats();
    });
  }

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
            Text(widget.date, style: theme.titleMedium),
            10.height,

            /// ROUTE
            _routeSection(theme),

            12.height,
            _seatSelector(theme),
            12.height,

            /// PRICE SUMMARY
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                final totalPrice = calculateTotalPrice();
                return _priceSummary(theme, homeProvider.seats, totalPrice);
              },
            ),

            12.height,

            /// PAYMENT METHOD
            _paymentMethodSection(theme),

            12.height,

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
        Column(children: [30.height, _dot(), _line(), _dot()]),
        14.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationTile(
                time: widget.originTime,
                title: widget.originCity,
                subtitle: widget.originAddress,
                theme: theme,
              ),
              20.height,
              _locationTile(
                time: widget.destinationTime,
                title: widget.destinationCity,
                subtitle: widget.destinationAddress,
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

  Widget _priceSummary(TextTheme theme, int seats, double totalPrice) {
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
                  formatPrice(widget.seatPrice),
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
                  seats.toString(),
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
                  totalPrice.toString(),
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
        inputFormatters: [FirstLetterCapitalFormatter()],
        decoration: InputDecoration(
          hintText:
              "Hello, I've just booked your ride! I'd be glad to travel with you.",
          hintStyle: theme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _seatSelector(TextTheme theme) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Container(
          padding: 14.hv(16),
          margin: .only(bottom: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(14.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Number of Seats', style: theme.bodyLarge),
              Row(
                children: [
                  _seatButton(Icons.remove, () {
                    homeProvider.decrement();
                  }),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text(
                      "${homeProvider.seats}",
                      style: theme.titleMedium,
                    ),
                  ),
                  _seatButton(Icons.add, () {
                    homeProvider.increment();
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _seatButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(20.r),
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: appColor.backgroundColor,
        child: Icon(icon, color: appColor.mainColor, size: 18.sp),
      ),
    );
  }

  Widget _bottomButton() {
    return Consumer<BookingRequestProvider>(
      builder: (BuildContext context, provider, child) {
        return BottomAppBar(
          child: SizedBox(
            height: 56.h,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await provider.bookingRequest(
                  userId: userId!,
                  tripId: 2,
                  paymentMethod: "online",
                  paymentStatus: "pending",
                  seatRequest: 2,
                  totalPrice: 12.55,
                  specialMessage: "hello",
                );
                print("UserId is this ${userId}");
                // appNavigator.push(BookingDoneScreen());

                //BookingDoneScreen(paymentMethod: _selectedPaymentMethod),
              },
              icon: const Icon(Icons.event_seat),
              label: const Text('Request to book'),
            ),
          ),
        );
      },
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
