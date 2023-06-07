import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!.uid;
  String name = '';
  String role = '';
  String dob = 'db get';
  String gender = 'db get';
  String nationality = 'db get';
  String program = 'db get';
  String roomNo = 'db get';
  String id = 'db get';

  @override
  void initState() {
    super.initState();
    getdatafromDB();
  }

  getdatafromDB() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(user) // Use the provided document ID
        .get();

    // Access the "role" field and convert it to a string
    String role = await snapshot.get('roles').toString();
    String name = await snapshot.get('name').toString();
    String dob = await snapshot.get('dob').toString();
    String email = await snapshot.get('email').toString();
    String program = await snapshot.get('program').toString();
    String id = await snapshot.get('id').toString();

    print(name + role);
    return [name, dob, email, program, role, id];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            // String name = snapshot.data as String;
            List<String> dataList = snapshot.data as List<String>;
            String name = dataList[0];
            String dob = dataList[1];
            String email = dataList[2];
            String program = dataList[3];
            String role = dataList[4];
            String id = dataList[5];

            return Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Personal Profile",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 100),
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
                                // color: Colors.blue,
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Date of Birth:",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Gender:",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Email:",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      role + " ID:",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Program:",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Hostel Room No:",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // color: Colors.cyan,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      dob,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      gender,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      email,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      id,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      program,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      roomNo,
                                      style: TextStyle(fontSize: 20),
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
            );
          },
        ),
      ),
    );
  }
}
