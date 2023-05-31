import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/test_widget.dart';
import 'package:flutter/material.dart';

class ShowRegisterdCarPage extends StatelessWidget {
  const ShowRegisterdCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(children: [
        TestWidget(),
        TestWidget(),
        TestWidget(),
      ]),
    );
  }
}
