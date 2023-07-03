import 'package:flutter/material.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({Key? key, required this.text}) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    e(context);
    return Scaffold(); // Return your desired widget here
  }
}

void e(context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        title: Text('Incorrect Email'),
      );
    },
  );
}
