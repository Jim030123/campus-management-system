import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../function/database.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyStudentDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: findUserById(userid),
          builder: (context, snapshot) {
            // String name = snapshot.data as String;

            DocumentSnapshot documentSnapshot = snapshot.data!;

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Personal Profile",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.grey,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          QrImageView(
                            backgroundColor: Colors.white,
                            data: user,
                            version: QrVersions.auto,
                            size: 150.0,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("user ID: " + user),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context)
                                            .size
                                            .width *
                                        0.8, // Set a maximum width for the program text
                                  ),
                                  // color: Colors.blue,
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: MyMiddleText(
                                            text: 'Basic information',
                                          )),
                                      MyDivider(),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Name: ' +
                                              documentSnapshot['name'] +
                                              "\nGender: " +
                                              documentSnapshot['gender'] +
                                              '\nDate of Birth: ' +
                                              documentSnapshot['dob'] +
                                              "\nNRIC: " +
                                              documentSnapshot['nric'] +
                                              "\nEmail: " +
                                              documentSnapshot['email'] +
                                              "\nRole: " +
                                              documentSnapshot['roles'] +
                                              "\nID: " +
                                              documentSnapshot['id'],
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder(
                                        future: fulldetail(
                                            documentSnapshot['roles']),
                                        builder: (context, snapshot) {
                                          List<String> roledetail =
                                              snapshot.data as List<String>;

                                          return roleinfo(
                                              documentSnapshot['roles'],
                                              roledetail);
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder(
                                        future: residentstudentdetail(),
                                        builder: (context, snapshot) {
                                          List<String> residentdetail =
                                              snapshot.data as List<String>;
                                          String roomtype = residentdetail[0];
                                          String status = residentdetail[1];

                                          return Column(
                                            children: [
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: MyMiddleText(
                                                    text:
                                                        'Resident information',
                                                  )),
                                              MyDivider(),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    children: [
                                                      Text("Room Type: " +
                                                          roomtype +
                                                          "\nStatus: " +
                                                          status)
                                                    ],
                                                  ))
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

residentstudentdetail() async {
  final user = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('resident_application') // Replace with your collection name
      .doc(user) // Use the provided document ID
      .get();

  String roomtype = snapshot.get('room_type');
  String status = snapshot.get('status');
  return [roomtype, status];
}

fulldetail(String role) async {
  final user = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users') // Replace with your collection name
      .doc(user) // Use the provided document ID
      .get();

  String homeaddress = snapshot.get('home_address').toString();
  String postcode = snapshot.get('postcode').toString();
  String nationality = snapshot.get('nationality').toString();

  String parentname = snapshot.get('parent_name');
  String relationship = snapshot.get('relationship');
  String parentemail = snapshot.get('parent_email');
  String parentcontactno = snapshot.get('parent_contact_no');

  if (nationality == "National Resident") {
    String state = snapshot.get('state').toString();

    return [
      nationality,
      state,
      postcode,
      homeaddress,
      parentname,
      relationship,
      parentemail,
      parentcontactno
    ];
  } else if (nationality == "country") {
    String country = snapshot.get('country').toString();
    return [
      nationality,
      country,
      postcode,
      homeaddress,
      parentname,
      relationship,
      parentemail,
      parentcontactno
    ];
  }
}

roleinfo(String role, List roledetail) {
  String nationality = roledetail[0];

  if (role == "Student" && nationality == "Foreign Resident") {
    String stateOrcountry = roledetail[1];
    String postcode = roledetail[2];
    String homeaddress = roledetail[3];
    String parentname = roledetail[4];
    String relationship = roledetail[5];
    String parentemail = roledetail[6];
    String parentcontactno = roledetail[7];

    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: MyMiddleText(
              text: role + ' information',
            )),
        MyDivider(),
        Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text('Nationality : ' +
                    nationality +
                    '\nState : ' +
                    stateOrcountry +
                    '\nPostcode : ' +
                    postcode +
                    '\nHome Address: ' +
                    homeaddress +
                    '\nParent Name : ' +
                    parentname +
                    '\nRelationship : ' +
                    relationship +
                    '\nParent Email : ' +
                    parentemail +
                    '\nParent Contact No: ' +
                    parentcontactno)
              ],
            ))
      ],
    );
  } else {
    return Container();
  }
}
