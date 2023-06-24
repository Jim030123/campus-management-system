import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 25,
      color: Colors.black,
      thickness: 2,
    );
  }
}
