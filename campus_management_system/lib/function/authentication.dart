import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void handleLogout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  // Redirect the user to the login page
  Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
}
