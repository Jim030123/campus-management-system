import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking_screen.dart';

class FacilityStatusScreen extends StatefulWidget {
  @override
  _FacilityStatusScreenState createState() => _FacilityStatusScreenState();
}

class _FacilityStatusScreenState extends State<FacilityStatusScreen> {
  final BookingService _bookingService = BookingService();
  DateTime? selectedDate; // Nullable DateTime

  final List<String> timeSlots = [
    '8AM - 10AM',
    '10AM - 12PM',
    '12PM - 2PM',
    '2PM - 4PM',
    '4PM - 6PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Facility Status')),
      body: Column(
        children: [
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 30)),
              );
              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
              }
            },
            child: Text(selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
          ),
          if (selectedDate != null)
            StreamBuilder<QuerySnapshot>(
              stream: _bookingService.getBookingsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final bookings = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final timeSlot = timeSlots[index];
                      final isBooked = bookings.any(
                        (booking) =>
                            booking['timeSlot'] ==
                            '${selectedDate!.toLocal()} - $timeSlot',
                      );

                      return ListTile(
                        title: Text(timeSlot),
                        trailing: Text(
                          isBooked ? 'Booked' : 'Available',
                          style: TextStyle(
                            color: isBooked ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
