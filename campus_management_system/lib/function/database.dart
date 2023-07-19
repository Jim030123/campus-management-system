import 'package:cloud_firestore/cloud_firestore.dart';

List role = ['Student', 'Management', 'Visitor'];



Future<DocumentSnapshot> findUserById(String userid) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    return user;
  }

