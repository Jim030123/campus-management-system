import 'package:campus_management_system/pages/redirect_login_page.dart';
import 'package:campus_management_system/pages/main_page.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_or_register_page.dart';
import 'main_page.dart';

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
            // uid not refresh

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
