import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    
    String model = "ds";
    String regdate = "dsa";
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          leading: Text("1.", style: TextStyle(fontSize: 20)),
          title: Text("Car Plate Number"),
          subtitle: Text("Register Date:" +
              regdate +
              "\nModel: " +
              model +
              "\nModel: " +
              model),
          trailing: Image.asset('lib/images/car.jpg'),
          tileColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
