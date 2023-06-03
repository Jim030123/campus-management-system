import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final user = FirebaseAuth.instance.currentUser!;

 setprofile() {
  Widget build(BuildContext context) {
    return Text(user.uid);
  }
}
