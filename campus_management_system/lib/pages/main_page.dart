import "package:campus_management_system/components/my_drawer.dart";
import "package:campus_management_system/components/my_listtile.dart";
import "package:campus_management_system/components/my_logo.dart";
import "package:campus_management_system/components/my_switchlisttile.dart";
import "package:campus_management_system/components/my_tile.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:qr_flutter/qr_flutter.dart";

class StudentMainPage extends StatefulWidget {
  StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser!;

class _StudentMainPageState extends State<StudentMainPage> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    String batch = 'db get';
    String studentID = 'db get';
    String name = 'db get';
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // width: 1000,
            height: 1200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyLogo(),
                Container(
                  padding: EdgeInsets.all(8),
                  // width: 2000,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    // border: Border.all(
                    //   color: Colors.black,
                    // ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      "Student Information",
                      style: TextStyle(fontSize: 30),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Name:" +
                                      name +
                                      "\nBatch:" +
                                      batch +
                                      "\nStudent ID:" +
                                      studentID,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                QrImageView(
                                  data: user.uid,
                                  version: QrVersions.auto,
                                  size: 75.0,
                                ),
                                Text(
                                  "user ID: \n" + user.uid,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 9),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyMenuTile(
                        text: 'Student Resident',
                        iconnumber: 0xf07dd,
                        routename: '/resident_menu'),
                    MyMenuTile(
                        text: 'Security',
                        iconnumber: 0xf013e,
                        routename: '/security_menu'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyMenuTile(
                        text: 'Facility',
                        iconnumber: 0xf01c8,
                        routename: '/facility_menu'),
                    MyMenuTile(
                        text: 'Feedback',
                        iconnumber: 0xf73b,
                        routename: '/feedback_menu'),
                  ],
                ),
                SizedBox(
                  width: 25,
                ),
                Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyMenuTile(
                        text: 'Add Student',
                        iconnumber: 0xf7c5,
                        routename: '/student_resident_menu'),
                    // MyMenuTile(),
                    // MyMenuTile(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // color: Colors.green,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200), topRight: Radius.circular(200)),
          color: Colors.black54,
        ),
        // color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.account_circle_rounded,
                    size: 30,
                  ),
                  tooltip: 'User Profile',
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  }),
              IconButton(
                  icon: const Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  tooltip: 'Log Out',
                  onPressed: () {
                    setState(() {
                      setState(() {
                        _visible = !_visible;

                        if (_visible = true) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Are You Sure Want to Log Out"),
                              content: const Text(
                                  "If you are Log Out need to sign in again"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(14),
                                          child: const Text(
                                            "Yes",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onTap: () {
                                          handleLogout();
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      });
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }

  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Redirect the user to the login page
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }
}
