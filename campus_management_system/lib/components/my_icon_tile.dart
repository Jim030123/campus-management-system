import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyIconTile extends StatelessWidget {
  MyIconTile({super.key, required this.iconnumber, required this.text});

  String text;
  int iconnumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 130,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.brown,
        ),
        child: Column(
          children: [
            Icon(
              IconData(iconnumber, fontFamily: 'MaterialIcons'),
              size: 50,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
