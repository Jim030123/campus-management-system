import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking_screen.dart';

class FacilityStatusScreen extends StatefulWidget {
  @override
  _FacilityStatusScreenState createState() => _FacilityStatusScreenState();
}

class _FacilityStatusScreenState extends State<FacilityStatusScreen> {
  final List<String> facilities = [
    'badminton_court',
    'tennis_court',
    'basketball_court'
  ];
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedDate == null)
              Text(
                'Please select a date first.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text(selectedDate == null
                  ? 'Select Date'
                  : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
            ),
            if (selectedDate != null)
              Expanded(
                child: ListView.builder(
                  itemCount: facilities.length,
                  itemBuilder: (context, facilityIndex) {
                    final facilityType = facilities[facilityIndex];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            facilityType.replaceAll('_', ' ').capitalize,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          shrinkWrap: true,
                          itemCount: timeSlots.length,
                          itemBuilder: (context, timeSlotIndex) {
                            final timeSlot = timeSlots[timeSlotIndex];

                            return TimeSlotContainer(
                              timeSlot: timeSlot,
                              selectedDate: selectedDate!,
                              selectedFacility: facilityType,
                            );
                          },
                        ),
                        SizedBox(height: 25),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String get capitalize {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
