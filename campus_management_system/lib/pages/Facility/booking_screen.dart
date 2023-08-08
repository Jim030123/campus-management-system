import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BookingService {
  final CollectionReference _bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');
  Future<void> bookFacility(String timeSlot, String facilityName) async {
    String facilityPassID = Uuid().v4();
    final user = FirebaseAuth.instance.currentUser!.uid;

    try {
      await _bookingsCollection.add({
        'facilityName': facilityName,
        'timeSlot': timeSlot,
        'isAvailable': false,
        'id': user,
        'facility_pass_id': facilityPassID
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

  Stream<QuerySnapshot> getBookingsStream(String facilityName) {
    return _bookingsCollection
        .where('facilityName', isEqualTo: facilityName)
        .snapshots();
  }

  Future<bool> isTimeSlotAvailable(String timeSlot, String facilityName) async {
    try {
      final snapshot = await _bookingsCollection
          .where('timeSlot', isEqualTo: timeSlot)
          .where('facilityName', isEqualTo: facilityName)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}

class BookingScreen extends StatefulWidget {
  final String facilityName;

  BookingScreen({required this.facilityName});

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
      appBar: AppBar(title: Text('Book ${widget.facilityName}')),
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
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      _bookingService.getBookingsStream(widget.facilityName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final bookings = snapshot.data?.docs ?? [];

                      return ListView.builder(
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
                            trailing: ElevatedButton(
                              onPressed: isBooked
                                  ? null
                                  : () async {
                                      await _bookingService.bookFacility(
                                        '${selectedDate!.toLocal()} - $timeSlot',
                                        widget.facilityName,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Facility booked successfully!'),
                                        ),
                                      );
                                    },
                              child: Text('Book'),
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
      ),
    );
  }
}

class TimeSlotContainer extends StatelessWidget {
  final String timeSlot;
  final DateTime selectedDate;
  final String selectedFacility;

  const TimeSlotContainer({
    required this.timeSlot,
    required this.selectedDate,
    required this.selectedFacility,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BookingService().isTimeSlotAvailable(
        '${selectedDate.toLocal()} - $timeSlot',
        selectedFacility,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final isAvailable = snapshot.data ?? false;

        return GestureDetector(
          onTap: () {
            if (isAvailable) {
              BookingService().bookFacility(
                '${selectedDate.toLocal()} - $timeSlot',
                selectedFacility,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Facility booked successfully!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Facility is already booked!')),
              );
            }
          },
          child: Container(
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
          ),
        );
      },
    );
  }
}
