import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyLongButton extends StatelessWidget {
  MyLongButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Align(
            child: Text('Log out'), alignment: AlignmentDirectional.center),
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.popAndPushNamed(context, '/');
      },
    );
  }
}
