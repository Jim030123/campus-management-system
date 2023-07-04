import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  // Set the filter value here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              emailsCollection.where('visitorid', isEqualTo: uid).snapshots(),
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
                  final filter = emails[index].data() as Map<String, dynamic>;
                  int index1 = index + 1;

                  // Customize the list item widget based on your requirements
                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: ListTile(
                        tileColor: Colors.grey,
                        title: Text(filter['reason'] +
                            "\nVistit time: " +
                            filter['date_visit'] +
                            " " +
                            filter['time_visit'] +
                            "\nSubmit Time: " +
                            filter['timestamp']),
                        leading: Text(index1.toString()),
                        trailing: QRTrailer(filter)),
                  );
                },
              );
            }

            return Text('No emails found.');
          },
        ),
      ),
    );
  }

  QRTrailer(Map<String, dynamic> filter) {
    if (filter['status'] == "Approved") {
      return GestureDetector(
        child: Text(
          textAlign: TextAlign.center,
          "\nView QR Code here",
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
                      data: filter['visitorpassid'],
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                    Text("Visitor Pass ID:" + filter['visitorpassid']),
                    MyDivider(),
                    MyMiddleText(
                        text: "Date Time: " +
                            filter['date_visit'] +
                            "\nEntry Time: " +
                            filter['entry_time'] +
                            "\nReason: " +
                            filter['reason'] +
                            "\n Exit Time : " +
                            filter['exit_time'])
                  ],
                ),
              ));
            },
          );
        },
      );
    } else if (filter['status'] == "Waiting the Management Review") {
      return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.yellow,
          ),
          child: Text(
            "Waiting the Management Review",
          ));
    } else if (filter['status'] == "Declined") {
      return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.red,
          ),
          child: Text(
            "Declined",
          ));
    } else {
      return;
    }
  }
}
