import 'package:flutter/material.dart';

class MyMenuTile extends StatelessWidget {
  const MyMenuTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
  ),
);
  }
}
