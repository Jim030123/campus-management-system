import "package:campus_management_system/components/my_drawer.dart";
import "package:campus_management_system/components/my_listtile.dart";
import "package:campus_management_system/components/my_switchlisttile.dart";
import "package:campus_management_system/components/my_tile.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser!;

class _MainPageState extends State<MainPage> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    String batch = 'db get';
    String studentID = 'db get';
    String name = 'db get';
    String role = 'db get';
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: 1000,
            height: 1000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 2000,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text(
                        role + " Information",
                        style: TextStyle(fontSize: 45),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Column(
                            children: [
                              Text(
                                "Name:" +
                                    name +
                                    "\nBatch:" +
                                    batch +
                                    "\nStudent ID:" +
                                    studentID,
                                style: TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyMenuTile(),
                    MyMenuTile(),
                    MyMenuTile(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyMenuTile(),
                    MyMenuTile(),
                    MyMenuTile(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyMenuTile(),
                    MyMenuTile(),
                    MyMenuTile(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        // color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.account_circle_rounded,
                    size: 45,
                  ),
                  tooltip: 'User Profile',
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(
                    Icons.logout,
                    size: 45,
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

                          // Container(
                          //   margin: EdgeInsets.only(bottom: 10, right: 10),
                          //   width: 200.0,
                          //   height: 250.0,
                          //   child: ListView(children: [
                          //     MyListTile(
                          //         carmodel: 'sad', carplatenumber: 'fdf'),
                          //     MyListTile(
                          //         carmodel: 'sad', carplatenumber: 'fdf'),
                          //     MyListTile(
                          //         carmodel: 'sad', carplatenumber: 'fdf'),
                          //     MyListTile(
                          //         carmodel: 'sad', carplatenumber: 'fdf')
                          //   ]),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(25),
                          //       color: Colors.grey),
                          // );
                        }
                      });
                      // showDialog(
                      //   context: context,
                      //   builder: (ctx) => AlertDialog(
                      //     title: const Text("Alert Dialog Box"),
                      //     content:
                      //         const Text("You have raised a Alert Dialog Box"),
                      //     actions: <Widget>[
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.of(ctx).pop();
                      //         },
                      //         child: Container(
                      //           color: Colors.green,
                      //           padding: const EdgeInsets.all(14),
                      //           child: const Text("okay"),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // );
                      // Stack(children: <Widget>[
                      //   Container(
                      //     width: 300,
                      //     height: 300,
                      //     color: Colors.red,
                      //     padding: EdgeInsets.all(15.0),
                      //     alignment: Alignment.topRight,
                      //     child: Text(
                      //       'One',
                      //       style: TextStyle(color: Colors.white),
                      //     ), //Text
                      //   ),
                      // ]);
                    });
                  })
            ],
          ),
        ),
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(200), topRight: Radius.circular(200)),
            color: Color.fromARGB(255, 97, 209, 101)),
      ),
    );
  }

  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Redirect the user to the login page
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }
}
