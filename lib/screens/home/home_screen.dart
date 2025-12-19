import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  int seats = 1;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('CARPOOL'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              Icon(Icons.notifications, size: 26.sp),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 7.r,
                  backgroundColor: Colors.red,
                  child: Text(
                    '11',
                    style: theme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 9.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: 16.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Find Ride', style: theme.titleMedium),
            16.height,

            _inputTile(
              icon: Icons.my_location,
              hint: 'Enter Pickup Location',
              theme: theme,
            ),
            _inputTile(
              icon: Icons.location_on,
              hint: 'Enter Drop Location',
              theme: theme,
            ),

            _seatSelector(theme),

            14.height,

            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: 18.hv(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date of Departure', style: theme.bodySmall),
                        4.height,
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: theme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.calendar_month,
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            ),

            26.height,

            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.search, size: 20.sp),
                    4.width,
                    Text('SEARCH RIDE'),
                  ],
                ),
              ),
            ),

            30.height,

            Text('Exclusive Offer', style: theme.titleMedium),
            12.height,

            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_D4QEFHiMTxClosCqqzasjAIj5e4r3auUZHcyi5kCfYnLKu4OBQ4ogKJNvhD2PZLwMjo&usqp=CAU',
                height: 150.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- SEAT SELECTOR ----------------

  Widget _seatSelector(TextTheme theme) {
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
                if (seats > 1) setState(() => seats--);
              }),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text('$seats', style: theme.titleMedium),
              ),
              _seatButton(Icons.add, () {
                if (seats < 8) setState(() => seats++);
              }),
            ],
          ),
        ],
      ),
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

  /// ---------------- INPUT TILE ----------------

  Widget _inputTile({
    required IconData icon,
    required String hint,
    required TextTheme theme,
  }) {
    return Container(
      margin: .only(bottom: 12.h),
      padding: .symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .circular(14.r),
      ),
      child: TextField(
        style: theme.bodyLarge,
        decoration: InputDecoration(
          icon: Icon(icon, size: 24.sp),
          hintText: hint,
        ),
      ),
    );
  }
}
