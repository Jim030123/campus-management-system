import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                        "Campus Management System",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                )),
          ]),
    );
  }
}
