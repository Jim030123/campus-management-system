import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyMenuTile extends StatelessWidget {
  const MyMenuTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Icon(Icons.safety_check, size: 40),
          SizedBox(
            height: 20,
          ),
          Text(
            "TEXT",
            style: TextStyle(fontSize: 20),
          ),
        ]),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/sample_home');
      },
    );
  }
}