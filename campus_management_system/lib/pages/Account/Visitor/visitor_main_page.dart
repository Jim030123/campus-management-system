import 'package:campus_management_system/components/my_button.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_management_system/function/database.dart';

class VisitorMainPage extends StatefulWidget {
  const VisitorMainPage({super.key});

  @override
  State<VisitorMainPage> createState() => _VisitorMainPageState();
}

class _VisitorMainPageState extends State<VisitorMainPage> {
  String userid = FirebaseAuth.instance.currentUser!.uid;

  get onTap => null;
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: findUserById(userid),
      builder: (context, snapshot) {
        DocumentSnapshot documentSnapshot = snapshot.data!;

        if (documentSnapshot['full_detail'] == "0") {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushReplacementNamed(
                context, '/redirect_visitor_personal_form');
          });
        }
        return Scaffold(
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // column child

              children: [
                SizedBox(
                  height: 70.0,
                ),

                SizedBox(
                  height: 50.0,
                ),
                // Allign center
                MyLogo(),

                SizedBox(
                  height: 25.0,
                ),

                Container(
                  // color: Colors.red,
                  width: 300,
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/register_visitor_pass');
                        },
                        text: 'Register Visitor Pass',
                      ),
                      MyButton(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/visitor_pass_progress');
                          },
                          text: 'View Progress'),
                      MyButton(onTap: onTap, text: 'View Visitor Pass'),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Container(
            // color: Colors.green,
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
                        Navigator.pushNamed(context, '/visitor_profile_page');
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
                                  title: const Text(
                                      "Are You Sure Want to Log Out"),
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
                        });
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleLogout() async {
    await FirebaseAuth.instance.signOut();
    // Redirect the user to the login page
    Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
  }
}
