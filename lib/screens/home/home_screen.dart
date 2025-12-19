import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  int seats = 1; // seats count

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
    return Scaffold(
     // backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
       // backgroundColor: const Color(0xff2F5D50),
        elevation: 0,
        title: const Text(
          'CARPOOL',
         
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: const [
              Icon(Icons.notifications, size: 26),
              Positioned(
                right: 0,
                top: 0,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.red,
                  child: Text('11', style: TextStyle(fontSize: 9, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Find Ride', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _inputTile(icon: Icons.my_location, hint: 'Enter Pickup Location'),
            _inputTile(icon: Icons.location_on, hint: 'Enter Drop Location'),

            // seat selector
            _seatSelector(),

            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date of Departure', style: TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Icon(Icons.calendar_month, color: Color(0xff2F5D50)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.search),
                label: const Text('SEARCH RIDE', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2F5D50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Text('Exclusive Offer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_D4QEFHiMTxClosCqqzasjAIj5e4r3auUZHcyi5kCfYnLKu4OBQ4ogKJNvhD2PZLwMjo&usqp=CAU',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Seat selector widget
  Widget _seatSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Number of Seats', style: TextStyle(fontSize: 15)),
          Row(
            children: [
              _seatButton(Icons.remove, () {
                if (seats > 1) setState(() => seats--);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('$seats', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _seatButton(Icons.add, () {
                if (seats < 8) setState(() => seats++);
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _seatButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: appColor.backgroundColor
        ,
        child: Icon(icon, color: appColor.mainColor),
      ),
    );
  }

  Widget _inputTile({required IconData icon, required String hint}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: TextField(
        decoration: InputDecoration(icon: Icon(icon), hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
