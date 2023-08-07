import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking_screen.dart';

class FacilityStatusScreen extends StatefulWidget {
  @override
  _FacilityStatusScreenState createState() => _FacilityStatusScreenState();
}

class _FacilityStatusScreenState extends State<FacilityStatusScreen> {
  final List<String> timeSlots = [
    '8AM - 10AM',
    '10AM - 12PM',
    '12PM - 2PM',
    '2PM - 4PM',
    '4PM - 6PM',
  ];
  DateTime? selectedDate;
  String selectedFacility = 'badminton_court'; // Default facility name

  Future<void> _selectDate(BuildContext context) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Facility Status')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
          ),
          DropdownButton<String>(
            value: selectedFacility,
            onChanged: (value) {
              setState(() {
                selectedFacility = value!;
              });
            },
            items: [
              'badminton_court',
              'another_facility_name',
              'basketball_facility'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          if (selectedDate != null)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: BookingService().getBookingsStream(selectedFacility),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    final bookings = snapshot.data?.docs ?? [];

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = timeSlots[index];
                        final isBooked = bookings.any(
                          (booking) =>
                              booking['timeSlot'] ==
                              '${selectedDate!.toLocal()} - $timeSlot',
                        );

                        return Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isBooked ? Colors.red : Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                timeSlot,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isBooked ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                isBooked ? 'Booked' : 'Available',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isBooked ? Colors.white : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
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
