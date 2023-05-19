import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {super.key, required this.carmodel, required this.carplatenumber});

  final String carplatenumber;
  final String carmodel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.car_rental),
      title: Text(carplatenumber),
      subtitle: Text(carmodel),
      trailing: Image.asset(
        'lib/images/logo.png',
      ),
    );
  }
}
