import 'package:flutter/material.dart';

class AutoFillFormMenu extends StatelessWidget {
  final String scannedData;

  const AutoFillFormMenu({Key? key, required this.scannedData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Fill Form Page'),
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text("Please select the form you want auto fill:" + scannedData,
            style: TextStyle(fontSize: 30)),
        ElevatedButton(
          onPressed: () {},
          child: Text('Add Resident Student', style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Add Vehicle Car', style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Add Visitor Pass', style: TextStyle(fontSize: 20)),
        ),
      ]),
    );
  }
}
