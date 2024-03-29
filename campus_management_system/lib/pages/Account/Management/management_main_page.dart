import "package:campus_management_system/components/my_logo.dart";
import "package:campus_management_system/components/my_tile.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "package:qr_flutter/qr_flutter.dart";

class ManagementMainPage extends StatefulWidget {
  ManagementMainPage({super.key});

  @override
  State<ManagementMainPage> createState() => _ManagementMainPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _ManagementMainPageState extends State<ManagementMainPage> {
  bool _visible = true;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    getdatafromDB() async {
      final user = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(user) // Use the provided document ID
          .get();

      String name = await snapshot.get('name');
      String email = await snapshot.get('email');
      String id = await snapshot.get('id');
      String fulldetail = await snapshot.get('full_detail');
      return [name, email, id, fulldetail];
    }

    return Scaffold(
      body: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or any loading indicator
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred while loading data'),
              );
            } else {
              List<String> dataList = snapshot.data as List<String>;

              String name = dataList[0];
              String email = dataList[1];
              String id = dataList[2];
              String fulldetail = dataList[3];

              if (fulldetail == "0") {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.pushReplacementNamed(
                      context, '/redirect_personal_form');
                });
              }

              return SingleChildScrollView(
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
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            // border: Border.all(
                            //   color: Colors.black,
                            // ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(children: [
                            Text(
                              "Management Staff Information",
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
                                              "\nBatch: " +
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
                            MyMenuTile(
                                text: 'Account Management',
                                iconnumber: 0xf7c5,
                                routename: '/account_management_menu'),
                            MyMenuTile(
                                text: 'Dashboard',
                                iconnumber: 0xe1b1,
                                routename: '/dashboard'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyMenuTile(
                                text: 'Feedback Recieved',
                                iconnumber: 0xe260,
                                routename: '/feedback_received'),
                            MyMenuTile(
                                text: 'Visitor Pass Management',
                                iconnumber: 0xef2e,
                                routename: '/visitor_pass_management')
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyMenuTile(
                                text: 'Security Management',
                                iconnumber: 0xf013e,
                                routename: '/security_management_menu'),
                            MyMenuTile(
                                text: 'Student Resident Management',
                                iconnumber: 0xf0110,
                                routename: '/student_resident_management_menu'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyMenuTile(
                                text: 'Auto fill Form',
                                iconnumber: 0xf60d,
                                routename: '/auto_fill_form_menu'),
                            MyMenuTile(
                                text: 'Facility Management',
                                iconnumber: 0xece9,
                                routename: '/facility_management_menu'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: Container(
        // color: Colors.green,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200), topRight: Radius.circular(200)),
          color: Colors.black54,
        ),

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
                    Navigator.pushNamed(context, '/management_profile');
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
