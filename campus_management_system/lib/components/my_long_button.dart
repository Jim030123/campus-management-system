import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyLongButton extends StatelessWidget {
  MyLongButton({super.key, required this.text, required this.routename});

  String text;
  String routename;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Align(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 25),
              ),
            ),
            alignment: AlignmentDirectional.center),
        width: 300,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, routename);
      },
    );
  }
}
