import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyButton2 extends StatefulWidget {
  const MyButton2({
    super.key,
    required this.buttonText,
  });

  final String buttonText;

  @override
  State<MyButton2> createState() => _MyButton2State();
}

class _MyButton2State extends State<MyButton2> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: Text(widget.buttonText),
        onPressed: () {
          GoRouter.of(context).go('/management');
        });
  }
}
