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

    // Access the "role" field and convert it to a string
    String email = await snapshot.get('email').toString();
    String name = await snapshot.get('name').toString();
    String parentcontactno = await snapshot.get('parent_contact_no').toString();
    String parentname = await snapshot.get('parent_name').toString();
    String id = await snapshot.get('id').toString();
    String roomno = await snapshot.get('room_no').toString();
    String roomtype = await snapshot.get('room_type').toString();

    print(name + id);
    return [name, email, id, roomtype, roomno, parentname, parentcontactno];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: FutureBuilder(
            future: getdatafromDB(),
            builder: (context, snapshot) {
              List<String> dataList = snapshot.data as List<String>;
              String name = dataList[0];
              String email = dataList[1];
              String id = dataList[2];
              String roomtype = dataList[3];
              String roomno = dataList[4];
              String parentname = dataList[5];
              String parentcontactno = dataList[6];

              final user = FirebaseAuth.instance.currentUser!.uid;

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
                      Text('Name: ' + name),
                      Text('Email: ' + email),
                      Text('ID: ' + id),
                      Text('Room Type: ' + roomtype),
                      Text('Room No: ' + roomno),
                      Text('Parent Name:' + parentname),
                      Text('Parent Contact No: ' + parentcontactno),
                    ]),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MyLongButton(
                    text: 'Resident Feedback',
                    routename: '/resident_feedback',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MyLongButton(
                    text: 'Resident Facility',
                    routename: '/resident_facility',
                  ),
                ],
              ));
            }),
      ),
    );
  }
}
