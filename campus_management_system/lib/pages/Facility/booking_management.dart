import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BookingService {
  final CollectionReference _bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  Future<void> bookFacility(String timeSlot, String facilityName) async {
    DateTime registerTime = DateTime.now();
    String formattedTimeStamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(registerTime);

    String FacilityPassID = Uuid().v4();

    try {
      await _bookingsCollection.add({
        'facilityName': facilityName,
        'timestamp': formattedTimeStamp,
        'timeSlot': timeSlot,
        'isAvailable': false,
        'facility_pass_id': FacilityPassID,
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> cancelBooking(String timeSlot, String facilityName) async {
    try {
      final snapshot = await _bookingsCollection
          .where('timeSlot', isEqualTo: timeSlot)
          .where('facilityName', isEqualTo: facilityName)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final bookingId = snapshot.docs[0].id;
        await _bookingsCollection.doc(bookingId).delete();
      }
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

class FacilityManagement extends StatefulWidget {
  @override
  _FacilityManagementState createState() => _FacilityManagementState();
}

class _FacilityManagementState extends State<FacilityManagement> {
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
      appBar: AppBar(title: Text('Facility Management')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selectedDate == null)
              Text(
                'Please select a date you want to manage.',
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
                    final facilityName = facilities[facilityIndex];

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            facilityName.capitalize,
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

                            return TimeSlotContainerManagement(
                              timeSlot: timeSlot,
                              selectedDate: selectedDate!,
                              facilityName: facilityName,
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

class TimeSlotContainerManagement extends StatefulWidget {
  final String timeSlot;
  final DateTime selectedDate;
  final String facilityName;

  const TimeSlotContainerManagement({
    required this.timeSlot,
    required this.selectedDate,
    required this.facilityName,
  });

  @override
  _TimeSlotContainerManagementState createState() =>
      _TimeSlotContainerManagementState();
}

class _TimeSlotContainerManagementState
    extends State<TimeSlotContainerManagement> {
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    checkAvailability();
  }

  Future<void> checkAvailability() async {
    bool available = await BookingService().isTimeSlotAvailable(
      '${widget.selectedDate.toLocal()} - ${widget.timeSlot}',
      widget.facilityName,
    );
    setState(() {
      isAvailable = available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isAvailable) {
          await BookingService().bookFacility(
            '${widget.selectedDate.toLocal()} - ${widget.timeSlot}',
            widget.facilityName,
          );
        } else {
          await BookingService().cancelBooking(
            '${widget.selectedDate.toLocal()} - ${widget.timeSlot}',
            widget.facilityName,
          );
        }
        checkAvailability(); // Update the availability state
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
              widget.timeSlot,
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
  }
}
