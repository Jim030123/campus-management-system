import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../user/user.dart';

class MyTestPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserDocument() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentReference userDocRef =
            _firestore.collection('users').doc(user.uid);

        await userDocRef.set({
          'name': user.displayName,
          'email': user.email,
          // Add additional user data here
        });

        print('User document created successfully!');
      } catch (e) {
        print('Error creating user document: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create User Document'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Create User Document'),
            onPressed: () {
              fetchUsers();
            },
          ),
        ),
      ),
    );
  }
}
