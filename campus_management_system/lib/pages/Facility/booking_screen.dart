import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingService {
  final CollectionReference _bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  Future<void> bookFacility(String timeSlot) async {
    try {
      await _bookingsCollection.add({
        // 'userId': user.uid,
        'timeSlot': timeSlot,
        'isAvailable': false,
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookingsCollection.doc(bookingId).delete();
    } catch (e) {
      print('Error: $e');
    }
  }

  Stream<QuerySnapshot> getBookingsStream() {
    return _bookingsCollection.snapshots();
  }

  Future<bool> isTimeSlotAvailable(String timeSlot) async {
    try {
      final snapshot = await _bookingsCollection
          .where('timeSlot', isEqualTo: timeSlot)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService = BookingService();
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
      appBar: AppBar(title: Text('Book Facility')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(selectedDate == null
                ? 'Select Date'
                : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'),
          ),
          if (selectedDate != null)
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = timeSlots[index];

                  return ListTile(
                    title: Text(timeSlot),
                    trailing: FutureBuilder<bool>(
                      future: _bookingService.isTimeSlotAvailable(
                        '${selectedDate!.toLocal()} - $timeSlot',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        final isAvailable = snapshot.data ?? false;
                        return ElevatedButton(
                          onPressed: isAvailable
                              ? () async {
                                  await _bookingService.bookFacility(
                                    '${selectedDate!.toLocal()} - $timeSlot',
                                  );
                                  Navigator.pop(context);
                                }
                              : null,
                          child: Text('Book'),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}