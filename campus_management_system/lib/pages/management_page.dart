import 'package:campus_management_system/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:sliding_switch/sliding_switch.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

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
                child: Text('Switch to Visitor'),
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
                  MyButton(onTap: onTap, text: 'Log in Now'),
                  MyButton(onTap: onTap, text: 'About Us'),
                  GestureDetector(
                    child: SlidingSwitch(
                      value: false,
                      width: 250,
                      onChanged: (bool value) {
                        print(value);
                      },
                      height: 55,
                      animationDuration: const Duration(milliseconds: 400),
                      onTap: () {},
                      onDoubleTap: () {},
                      onSwipe: () {},
                      textOff: "Hostel Student",
                      textOn: "Management",
                      // iconOff: Icons.abc,
                      // iconOn: Icons.ac_unit,
                      contentSize: 17,
                      colorOn: const Color(0xffdc6c73),
                      colorOff: Color.fromARGB(255, 12, 89, 255),
                      background: Color.fromARGB(159, 44, 174, 203),
                      buttonColor: const Color(0xfff7f5f7),
                      inactiveColor: const Color(0xff636f7b),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
