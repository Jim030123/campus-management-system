import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewAllVisitorPass extends StatefulWidget {
  const ViewAllVisitorPass({super.key});

  @override
  State<ViewAllVisitorPass> createState() => _ViewAllVisitorPassState();
}

class _ViewAllVisitorPassState extends State<ViewAllVisitorPass> {
  final CollectionReference emailsCollection =
      FirebaseFirestore.instance.collection('visitor_pass_application');

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
                    "Visitor Pass Applications",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  MyDivider(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.block,
                        color: Colors.red,
                      ),
                      Text(" Decline")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.browse_gallery,
                        color: Colors.yellow,
                      ),
                      Text(" Waitting for Management Review")
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.blue,
                      ),
                      Text(" Expired")
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: emailsCollection
                    .where('visitorid', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
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
                            title: Text(filter['reason'] +
                                "\nVisitor Pass Type: " +
                                filter["visitor_pass_type"] +
                                declineReason(filter) +
                                "\nSubmit Time: " +
                                filter['timestamp']),
                            trailing: QRTrailer(filter),
                          ),
                        );
                      },
                    );
                  }

                  return Text('No emails found.');
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

      updateVPstatus(Map<String, dynamic> filter) async {
        await FirebaseFirestore.instance
            .collection('visitor_pass_application')
            .doc()
            .update({"status": "Expired"});
      }

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
                        MyMiddleText(
                          text: "Date Time: " +
                              filter['date_visit'] +
                              "\nEntry Time: " +
                              filter['entry_time'] +
                              "\nExit Time: " +
                              filter['exit_time'],
                        ),
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
}
