import 'package:flutter/material.dart';

class MySmallText extends StatelessWidget {
  MySmallText({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 18));
  }
}

class MyMiddleText extends StatelessWidget {
  MyMiddleText({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 24));
  }
}

class MyLargeText extends StatelessWidget {
  MyLargeText({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 30));
  }
}
