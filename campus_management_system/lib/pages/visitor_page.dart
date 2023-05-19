import 'package:campus_management_system/components/my_button.dart';
import 'package:flutter/material.dart';

class VisitorPage extends StatelessWidget {
  const VisitorPage({super.key});

  get onTap => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.grey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // column child

          children: [
            SizedBox(
              height: 70.0,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('Switch to Hostel Student / Management'),
                onPressed: () {
                  print('Hello');
                },
              ),
            ),

            SizedBox(
              height: 50.0,
            ),
            // Allign center
            Row(
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
                      width: 200,
                      height: 100,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Southern University College",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            "Campus Management Syetem",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                ]),

            SizedBox(
              height: 25.0,
            ),

            Container(
              // color: Colors.red,
              width: 300,
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(onTap: onTap, text: 'Register Visitor Pass'),
                  MyButton(onTap: onTap, text: 'View Progress'),
                  MyButton(onTap: onTap, text: 'View Visitor Pass'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
