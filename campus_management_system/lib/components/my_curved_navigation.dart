import 'package:campus_management_system/components/my_listtile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyBottomNav extends StatefulWidget {
  MyBottomNav({super.key});

  @override
  State<MyBottomNav> createState() => _MyBottomNavState();
}

class _MyBottomNavState extends State<MyBottomNav> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 10, right: 10),
              width: 200.0,
              height: 250.0,
              child: ListView(children: [
                MyListTile(carmodel: 'sad', carplatenumber: 'fdf'),
                MyListTile(carmodel: 'sad', carplatenumber: 'fdf'),
                MyListTile(carmodel: 'sad', carplatenumber: 'fdf'),
                MyListTile(carmodel: 'sad', carplatenumber: 'fdf')
              ]),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), color: Colors.grey),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.green,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(Icons.volume_up),
                    tooltip: 'User Profile',
                    onPressed: () {
                      
                    }),
                IconButton(
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      size: 40,
                    ),
                    tooltip: 'user',
                    onPressed: () {
                      setState(() {
                        setState(() {
                          _visible = !_visible;
                        });
                        // showDialog(
                        //   context: context,
                        //   builder: (ctx) => AlertDialog(
                        //     title: const Text("Alert Dialog Box"),
                        //     content:
                        //         const Text("You have raised a Alert Dialog Box"),
                        //     actions: <Widget>[
                        //       TextButton(
                        //         onPressed: () {
                        //           Navigator.of(ctx).pop();
                        //         },
                        //         child: Container(
                        //           color: Colors.green,
                        //           padding: const EdgeInsets.all(14),
                        //           child: const Text("okay"),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );
                        // Stack(children: <Widget>[
                        //   Container(
                        //     width: 300,
                        //     height: 300,
                        //     color: Colors.red,
                        //     padding: EdgeInsets.all(15.0),
                        //     alignment: Alignment.topRight,
                        //     child: Text(
                        //       'One',
                        //       style: TextStyle(color: Colors.white),
                        //     ), //Text
                        //   ),
                        // ]);
                      });
                    })
              ],
            ),
          ),
          height: 75,
        ));
  }
}
