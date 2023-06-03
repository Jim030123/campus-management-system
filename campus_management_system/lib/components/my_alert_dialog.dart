import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'my_appbar.dart';
import 'my_feedback_tile.dart';
import 'my_long_button.dart';
import '../documentation/term_and_condition.dart';

class MyAlertDialog extends StatelessWidget {
  MyAlertDialog({super.key, required this.text});
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AlertDialog(
      title: Text(text!),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            // Perform an action
            Navigator.of(context).pop();
          },
        ),
      ],
    ));
  }
}
