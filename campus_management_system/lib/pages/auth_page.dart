import 'package:campus_management_system/pages/general/redirect_page.dart';
import 'package:campus_management_system/pages/student/student_main_page.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/general/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'student/student_main_page.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return RedirectLoginPage();
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
