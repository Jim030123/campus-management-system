import "package:campus_management_system/components/my_drawer.dart";
import "package:campus_management_system/components/my_listtile.dart";
import "package:campus_management_system/components/my_switchlisttile.dart";
import "package:campus_management_system/components/my_tile.dart";
import "package:flutter/material.dart";

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
            MyMenuTile(),
          ]),
    );
  }
}
