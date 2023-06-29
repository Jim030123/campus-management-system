import 'package:campus_management_system/components/my_button.dart';
import 'package:campus_management_system/components/my_button2.dart';
import 'package:campus_management_system/components/my_logo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../components/my_long_button.dart';


class VisitorMenuPage extends StatefulWidget {
  VisitorMenuPage({
    super.key,
  });

  @override
  State<VisitorMenuPage> createState() => _VisitorMenuPageState();
}

class _VisitorMenuPageState extends State<VisitorMenuPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // pop the loading circle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // column child
                children: [
                  SizedBox(
                    height: 70.0,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      child: Text('Switch to Student / Management'),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                    ),
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
                        MyLongButton(
                          text: 'Register Visitor Pass',
                          routename: '/visitor_auth',
                        ),
                        MyLongButton(
                          text: 'View Visitor Pass',
                          routename: '',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
        );
  }
}
