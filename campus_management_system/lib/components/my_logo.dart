import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,

        // LOGO
        children: [
          Container(
            // color: Colors.indigoAccent,
            width: 100,
            height: 100,
            child: Image.asset(
              "lib/images/logo.png",
              width: 100,
              height: 100,
            ),
          ),

          // word
          Container(
              // color: Color.fromARGB(255, 56, 201, 97),
              width: 250,
              height: 100,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Campus Management System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              )),
        ]);
  }
}
