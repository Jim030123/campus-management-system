import "package:campus_management_system/components/my_listtile.dart";
import "package:campus_management_system/components/my_switchlisttile.dart";
import "package:flutter/material.dart";

class MyTestPage extends StatelessWidget {
  const MyTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.deepPurple[300],
            borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Text("data"),
          Text("data"),
          Row(
            children: [Text("data"), Text("data")],
          )
        ]),
      ),
    );
  }
}
