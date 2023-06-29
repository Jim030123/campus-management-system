import 'package:campus_management_system/components/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VisitorMainPage extends StatefulWidget {
  const VisitorMainPage({super.key});

  @override
  State<VisitorMainPage> createState() => _VisitorMainPageState();
}

class _VisitorMainPageState extends State<VisitorMainPage> {
  get onTap => null;
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          color: Colors.grey[300],
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  // LOGO
                  children: [
                    Container(
                      // color: Colors.indigoAccent,
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        "lib/images/logo.png",
                        width: 100,
                        height: 100,
                      ),
                    ),

                    // word
                    Container(
                        // color: Color.fromARGB(255, 56, 201, 97),
                        width: 200,
                        height: 100,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Southern University College",
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              "Campus Management Syetem",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                  ]),

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
                        Navigator.pushNamed(context, '/register_visitor_pass');
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
