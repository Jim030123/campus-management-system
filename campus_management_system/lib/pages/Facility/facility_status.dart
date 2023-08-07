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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
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
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
          ),
          if (selectedDate != null)
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = timeSlots[index];

                  return TimeSlotContainer(
                    timeSlot: timeSlot,
                    selectedDate: selectedDate!,
                  );
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

class TimeSlotContainer extends StatelessWidget {
  final String timeSlot;
  final DateTime selectedDate;

  const TimeSlotContainer({
    required this.timeSlot,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BookingService().isTimeSlotAvailable(
        '${selectedDate.toLocal()} - $timeSlot',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final isAvailable = snapshot.data ?? false;

        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isAvailable ? Colors.white : Colors.red,
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
                  color: isAvailable ? Colors.black : Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                isAvailable ? 'Available' : 'Booked',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isAvailable ? Colors.green : Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
