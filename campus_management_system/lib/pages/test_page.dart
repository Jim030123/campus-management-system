import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/my_appbar.dart';
import '../components/my_long_button.dart';

class MyTestPage extends StatelessWidget {
  const MyTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf01c8, text: 'Resident Student'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Add account',
            routename: '',
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'View All account',
            routename: '',
          ),
        ]),
      ),
    );
  }
}
