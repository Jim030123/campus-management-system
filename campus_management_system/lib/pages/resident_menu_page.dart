import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/my_long_button.dart';

class StudentResidentMenuPage extends StatelessWidget {
  const StudentResidentMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf07dd, text: 'Student Resident'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(text: 'Resident Application', routename: ''),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Resident Information',
            routename: '',
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Map',
            routename: '',
          ),
        ]),
      ),
    );
  }
}
