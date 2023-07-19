import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/my_long_button.dart';

class StudentResidentExist extends StatelessWidget {
  StudentResidentExist({super.key});

  getdatafromDB() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('resident_application') // Replace with your collection name
        .doc(user) // Use the provided document ID
        .get();

    String email = await snapshot.get('email').toString();
    String name = await snapshot.get('name').toString();
    String gender = await snapshot.get('gender').toString();
    String parentcontactno = await snapshot.get('parent_contact_no').toString();
    String parentname = await snapshot.get('parent_name').toString();
    String id = await snapshot.get('student_id').toString();

    String roomtype = await snapshot.get('room_type').toString();
    String relationship = await snapshot.get('relationship').toString();
    String roomno = await snapshot.get('room_no').toString();

    String status = await snapshot.get('status').toString();

    print(name + id);
    return [
      name,
      email,
      gender,
      id,
      roomtype,
      roomno,
      parentname,
      relationship,
      parentcontactno,
      status,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Container(
          padding: EdgeInsets.all(25),
          child: FutureBuilder(
              future: getdatafromDB(),
              builder: (context, snapshot) {
                List<String> dataList = snapshot.data as List<String>;
                String name = dataList[0];
                String email = dataList[1];
                String gender = dataList[2];
                String id = dataList[3];
                String roomtype = dataList[4];
                String roomno = dataList[5];
                String parentname = dataList[6];
                String relationship = dataList[7];
                String parentcontactno = dataList[8];
                String status = dataList[9];

                final user = FirebaseAuth.instance.currentUser!.uid;

                if (status == "Approved") {
                  Future.delayed(Duration.zero, () {
                    Navigator.pushReplacementNamed(context, '/payment_info');
                  });
                }
                return Container(
                    child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Student Resident Profile',
                          style: TextStyle(fontSize: 25),
                        )),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey,
                      ),
                      child: Column(children: [
                        QrImageView(
                          backgroundColor: Colors.white,
                          data: user,
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                        Text("User ID: " + user),
                        Text('Name: ' +
                            name +
                            '\nEmail: ' +
                            email +
                            '\nGender: ' +
                            gender +
                            '\nID: ' +
                            id +
                            '\nRoom Type: ' +
                            roomtype +
                            '\nRoom No: ' +
                            roomno +
                            '\nParent Name: ' +
                            parentname +
                            '\nRelationship: ' +
                            relationship +
                            '\nParent Contact No: ' +
                            parentcontactno +
                            '\nStatus: ' +
                            status),
                      ]),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    MyLongButton(
                      text: 'Resident Feedback',
                      routename: '/feedback_form',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ));
              }),
        ),
      ),
    );
  }
}
