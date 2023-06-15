import 'package:flutter/material.dart';

class MyMenuTile extends StatelessWidget {
  MyMenuTile(
      {super.key,
      required this.text,
      required this.iconnumber,
      required this.routename});

  String text;
  String routename;
  int iconnumber;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 175,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          Icon(IconData(iconnumber, fontFamily: 'MaterialIcons'), size: 80),
          SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ]),
      ),
      onTap: () {
        Navigator.pushNamed(context, routename);
      },
    );
  }
}
