
import 'package:flutter/material.dart';

import '../student/resident_form.dart';
import 'qr_auto_fill_.dart';

class AutoFillFormMenu extends StatelessWidget {
  AutoFillFormMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedbutton;
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Fill Form Page'),
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text("Please select the form you want auto fill:",
            style: TextStyle(fontSize: 30)),
        ElevatedButton(
          onPressed: () {
            selectedbutton = 1;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QRAutoFillFormPage(selectedbutton: selectedbutton)),
            );
          },
          child: Text('Add Resident Student', style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () {
            selectedbutton = 2;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QRAutoFillFormPage(selectedbutton: selectedbutton)),
            );
          },
          child: Text('Add Vehicle Car', style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () {
            selectedbutton = 3;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QRAutoFillFormPage(selectedbutton: selectedbutton)),
            );
          },
          child: Text('Add Visitor Pass', style: TextStyle(fontSize: 20)),
        ),
      ]),
    );
  }
}
