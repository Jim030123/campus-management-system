import 'package:campus_management_system/pages/Main_page.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/login_page.dart';
import 'package:campus_management_system/pages/sample_login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MainPage();
          }

          // user is not logged in
          else {
            return MyLoginPage();
          }
        },
      ),
    );
  }
}
