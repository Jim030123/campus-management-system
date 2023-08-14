import "package:campus_management_system/components/my_logo.dart";
import "package:campus_management_system/components/my_tile.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:qr_flutter/qr_flutter.dart";

class StudentMainPage extends StatefulWidget {
  StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

getdatafromDB() async {
  final user = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users') // Replace with your collection name
      .doc(user) // Use the provided document ID
      .get();

  // Access the "role" field and convert it to a string
  String name = await snapshot.get('name').toString();
  String email = await snapshot.get('email').toString();
  String id = await snapshot.get('id').toString();
  String fulldetail = await snapshot.get('full_detail').toString();
  return [name, email, id, fulldetail];
}

class _StudentMainPageState extends State<StudentMainPage> {
  bool _visible = true;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getdatafromDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Dialog(child: CircularProgressIndicator());

            // Display circular progress indicator while data is loading
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching data'), // Display error message
            );
          } else {
            List<String> dataList = snapshot.data as List<String>;
            String name = dataList[0];

            String email = dataList[1];

            String id = dataList[2];
            String full_detail = dataList[3];

            if (full_detail == "0") {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.pushReplacementNamed(
                    context, '/redirect_personal_form');
              });
            }

            return Scaffold(
              
              body: SingleChildScrollView(
                child: Center(
                  child: Container(
                    height: 1200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyLogo(),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(children: [
                            Text(
                              "Student Information",
                              style: TextStyle(fontSize: 30),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Name: " +
                                              name +
                                              "\nEmail: " +
                                              email +
                                              "\nStudent ID: " +
                                              id,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        QrImageView(
                                          data: user.uid,
                                          version: QrVersions.auto,
                                          size: 100.0,
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
                            FutureBuilder<MyMenuTile?>(
                              future: fetchUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While waiting for the data, you can display a loading indicator
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  // If an error occurs during data retrieval, you can display an error message
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // If the data retrieval is successful, you can display the MyMenuTile widget
                                  return snapshot.data ?? Container();
                                }
                              },
                            ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                      topRight: Radius.circular(200)),
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
                              _visible = !_visible;

                              if (_visible = true) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text(
                                        "Are You Sure Want to Log Out"),
                                    content: const Text(
                                        "If you sure to log out need to sign in again"),
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
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                                style: TextStyle(
                                                    color: Colors.white),
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
                          })
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Redirect the user to the login page
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }

  Future<MyMenuTile?> fetchUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('resident_application')
        .doc(uid)
        .get();

    if (snapshot.exists) {
      return MyMenuTile(
        text: 'Student Resident (Exist)',
        iconnumber: 0xf07dd,
        routename: '/resident_student',
      );
    } else {
      return MyMenuTile(
        text: 'Student Resident ',
        iconnumber: 0xf07dd,
        routename: '/resident_menu',
      ); // Return null if the document doesn't exist
    }
  }
}
