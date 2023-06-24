import 'package:flutter/material.dart';

class MyMiddleText extends StatelessWidget {
  MyMiddleText({super.key, required this.text});

  String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 24));
  }
}
