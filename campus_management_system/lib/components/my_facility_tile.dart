import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyFacilityTile extends StatelessWidget {
  const MyFacilityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(children: [
        Image.asset('lib/images/tennis.jpg', width: 350),
        Text(
          'Tennis Court',
          style: TextStyle(fontSize: 30),
        )
      ]),
    );
  }
}
