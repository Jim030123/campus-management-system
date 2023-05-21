import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class RolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> userRoles = Provider.of<List<String>>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userRoles.contains('admin')) Text('Admin Panel'),
            if (userRoles.contains('user')) Text('User Panel'),
          ],
        ),
      ),
    );
  }
}



FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential> signIn(String email, String password) async {
  return await _auth.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}


FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Example method to retrieve user roles from Firestore
Future<List<String>> getUserRoles(String userId) async {
  DocumentSnapshot snapshot = await _firestore
      .collection('users')
      .doc(userId)
      .get();

  if (snapshot.exists) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    if (userData.containsKey('roles')) {
      return List<String>.from(userData['roles']);
    }
  }

  return [];
}
