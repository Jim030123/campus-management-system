import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingFacilityHistory extends StatefulWidget {
  const BookingFacilityHistory({super.key});

  @override
  State<BookingFacilityHistory> createState() => _BookingFacilityHistoryState();
}

class _BookingFacilityHistoryState extends State<BookingFacilityHistory> {
  final CollectionReference facilityCollection =
      FirebaseFirestore.instance.collection('bookings');

  String uid = FirebaseAuth.instance.currentUser!.uid;
  int now = DateTime.now().millisecondsSinceEpoch;

  // Set the filter value here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.grey),
              child: Column(
                children: [
                  Text(
                    "Facility Booking History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    facilityCollection.where('id', isEqualTo: uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // or any loading indicator
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error occurred while loading data'),
                    );
                  } else {
                    final emails = snapshot.data!.docs;

                    print(emails.length);

                    return ListView.builder(
                      itemCount: emails.length,
                      itemBuilder: (context, index) {
                        final filter =
                            emails[index].data() as Map<String, dynamic>;

                        // Customize the list item widget based on your requirements
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(filter['facilityName'] +
                                "\n" +
                                filter['timeSlot']),
                            trailing: GestureDetector(
                              child: Text(
                                textAlign: TextAlign.center,
                                "\nView QR Code",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            QrImageView(
                                              data: filter['facility_pass_id'],
                                              version: QrVersions.auto,
                                              size: 150.0,
                                            ),
                                            Text("Facility Pass ID:" +
                                                "\n" +
                                                filter['facility_pass_id']),
                                            MyDivider(),
                                            MyMiddleText(
                                                text: filter['facilityName']),
                                            MyDivider(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
