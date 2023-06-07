import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RedirectLoginPage extends StatefulWidget {
  @override
  _RedirectLoginPageState createState() => _RedirectLoginPageState();
}

class _RedirectLoginPageState extends State<RedirectLoginPage> {
  Future<String> getRoleFieldValue(String documentId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(documentId) // Use the provided document ID
        .get();

    // Access the "role" field and convert it to a string
    String role = snapshot.get('roles').toString();
    print(role);

    if (role == 'Resident_Student') {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/student_main');
      });
    } else if (role == 'Management') {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/management_main');
      });
    }
    return role;
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser!.uid;
    getRoleFieldValue(user);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    'You are login as a ' +
                        'please wait' +
                        ' \nRedirecting to the Login Page...',
                    style: TextStyle(fontSize: 30)),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'You should be redirected automatically in 3 second if not please press Login Button',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () async {
                      getRoleFieldValue(user).toString();
                    },
                    child: Text('Main page'))
              ],
            )),
      ),
    );
  }
}
