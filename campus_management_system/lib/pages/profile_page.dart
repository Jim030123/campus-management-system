import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'Main_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String fullname = 'db get';
    String role = 'db get';
    String dob = 'db get';
    String gender = 'db get';
    String nationality = 'db get';
    String program = 'db get';
    String department = 'db get';
    String roomNo = 'db get';
    String id = 'db get';
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Container(
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
              // margin: EdgeInsets.symmetric(horizontal: 100),
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
                      data: user.uid,
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("user ID: " + user.uid),
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
                                  "Full name:",
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
                                  "Nationality:",
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
                                  "Department:",
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
                                  fullname,
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
                                  nationality,
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
                                  department,
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
        ),
      ),
    );
  }
}
