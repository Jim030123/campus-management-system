import 'package:flutter/material.dart';

class RegisterVisitorPass extends StatelessWidget {
  const RegisterVisitorPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(25),
      child: Center(
        child: Column(
          children: [
            Align(
                child: Text(
                  'Register Form',
                  style: TextStyle(fontSize: 30),
                ),
                alignment: Alignment.topLeft),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey,
              ),
              padding: EdgeInsets.all(25),
              child: Column(children: [
                Text(
                  'Please Register First!',
                  style: TextStyle(fontSize: 30),
                )
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
