import "package:flutter/material.dart";

class MyGridView extends StatelessWidget {
  const MyGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
          // MyMenuTile(),
        ]);
  }
}
