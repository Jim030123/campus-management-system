import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/pages/management/registration_account.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future createUser(TextEditingController nameController,contactnoController,emailController,idController , String formattedDob,_selectedRole,_selectedProgram ) async {
    String? uid;
    return await userCollection.doc(uid).set({
      "name": nameController.text,
      "dob": formattedDob,
      "contact_no": contactnoController.text,
      "email": emailController.text,
      "roles": _selectedRole as String,
      "program": _selectedProgram as String,
      "id": idController.text,
    });
  }
}
