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
                            title: Text(filter['facilityName']),
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
                                              data: filter['visitor_pass_id'],
                                              version: QrVersions.auto,
                                              size: 150.0,
                                            ),
                                            Text("Visitor Pass ID:" +
                                                "\n" +
                                                filter['visitor_pass_id']),
                                            MyDivider(),
                                            visitorType(filter),
                                            SizedBox(
                                              height: 25,
                                            ),
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

  QRTrailer(Map<String, dynamic> filter) {
    Timestamp expiredTimestamp = filter['expired_timestamp'];
    // DateTime expiredTime = filter['expired_timestamp'];
    // String formattedExpiredTime = DateFormat('yyyy-MM-dd').format(expiredTime);

    int expiredtime = expiredTimestamp.millisecondsSinceEpoch;
    print(expiredtime);
    print(now);

    DateTime vpexpiredtime = DateTime.fromMillisecondsSinceEpoch(expiredtime);

    // set status in firebase

    if (now > expiredtime) {
      // update status in firebase

      updateVPstatus(filter);

      return Icon(
        Icons.error_outline,
        color: Colors.blue,
        size: 40,
      );
    } else {
      if (filter['status'] == "Approved") {
        return GestureDetector(
          child: Text(
            textAlign: TextAlign.center,
            "\nView QR Code",
            style: TextStyle(decoration: TextDecoration.underline),
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
                          data: filter['visitor_pass_id'],
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                        Text("Visitor Pass ID:" +
                            "\n" +
                            filter['visitor_pass_id']),
                        MyDivider(),
                        visitorType(filter),
                        SizedBox(
                          height: 25,
                        ),
                        MyDivider(),
                        MySmallText(
                            text: "This visitor pass will expired at: " +
                                "\n" +
                                vpexpiredtime.toString())
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      } else if (filter['status'] == "Waiting the Management Review") {
        return Icon(
          Icons.browse_gallery,
          color: Colors.yellow,
        );
      } else if (filter['status'] == "Declined") {
        return Icon(
          Icons.block,
          color: Colors.red,
        );
      } else {
        return Container(); // You should return something for this case as well
      }
    }
  }

  declineReason(Map<String, dynamic> filter) {
    if (filter["status"] == "Declined") {
      return "\nDeclined Reason: " + filter["decline_reason"];
    } else {
      return "";
    }
  }

  updateVPstatus(Map<String, dynamic> filter) async {
    try {
      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(filter["visitor_pass_id"].toString())
          .update({"status": "Expired"});

      await FirebaseFirestore.instance
          .collection('vehicle')
          .doc(filter["vehicle_number"])
          .update({"status": "Expired"});
    } catch (e) {}
  }

  visitorType(Map<String, dynamic> filter) {
    if (filter["visitor_pass_type"] == "Short Term") {
      return MyMiddleText(
          text: "Date: " +
              filter['date_visit'] +
              "\nVisit Time: " +
              filter['time_visit']);
    } else if (filter["visitor_pass_type"] == "Long Term") {
      return MyMiddleText(
          text: "Start Date: " +
              filter['start_date_visit'] +
              "\nEnd Date: " +
              filter['end_date_visit']);
    }
  }
}
