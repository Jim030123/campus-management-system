import 'package:campus_management_system/pages/general/redirect_login_page.dart';
import 'package:campus_management_system/pages/student/student_main_page.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/general/login_page.dart';
import 'package:campus_management_system/pages/visitor/register_visitor_pass.dart';
import 'package:campus_management_system/pages/visitor/visitor_login.dart';
import 'package:campus_management_system/pages/visitor/visitor_register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VisitorAuthPage extends StatelessWidget {
  VisitorAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return RegisterVisitorPass();
          }

          // user is not logged in
          else {
            return VisitorLoginPage();
          }
        },
      ),
    );
  }
}
