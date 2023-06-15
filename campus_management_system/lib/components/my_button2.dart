import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyButton2 extends StatefulWidget {
  const MyButton2(
      {super.key, required this.buttonText, required this.routename});

  final String buttonText;
  final String routename;

  @override
  State<MyButton2> createState() => _MyButton2State();
}

class _MyButton2State extends State<MyButton2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(widget.buttonText),
        onPressed: () {
          GoRouter.of(context).go(widget.routename);
        });
  }
}
