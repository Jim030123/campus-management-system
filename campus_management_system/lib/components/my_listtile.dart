import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {super.key, required this.carmodel, required this.carplatenumber});

  final String carplatenumber;
  final String carmodel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: Icon(Icons.car_rental),
        title: Text(carplatenumber),
        subtitle: Text(carmodel),
        trailing: Image.asset(
          'lib/images/logo.png',
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/sample_home');
      },
    );
  }
}
