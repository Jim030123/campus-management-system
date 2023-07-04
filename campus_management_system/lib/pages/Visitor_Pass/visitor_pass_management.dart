import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';
import '../../components/my_drawer.dart';
import '../../components/my_icon_tile.dart';
import '../../components/my_logo.dart';
import '../../components/my_long_button.dart';

class VisitorPassManagementMenu extends StatefulWidget {
  const VisitorPassManagementMenu({super.key});

  @override
  State<VisitorPassManagementMenu> createState() =>
      _VisitorPassManagementMenuState();
}

class _VisitorPassManagementMenuState extends State<VisitorPassManagementMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyStudentDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf021b, text: 'Visitor Pass Management'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
              text: 'Visitor Pass Application',
              routename: '/visitor_pass_application'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Visitor Pass Scanner',
            routename: '/visitor_pass_scanner',
          ),
          SizedBox(
            height: 25,
          ),
        ]),
      ),
    );
  }
}
