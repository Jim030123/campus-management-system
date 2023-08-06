import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_appbar.dart';
import '../../components/my_long_button.dart';

class SecurityManagementMenu extends StatelessWidget {
  const SecurityManagementMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyManagementDrawer(),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(children: [
            MyLogo(),
            MyIconTile(iconnumber: 0xf013e, text: 'Security'),
            SizedBox(
              height: 25,
            ),
            MyLongButton(
              text: 'View All Vehicle ',
              routename: '/view_all_vehicle',
            ),
          
            SizedBox(
              height: 25,
            ),
            MyLongButton(
              text: 'Vehicle Entry Record',
              routename: '/log_book',
            ),
          ]),
        ),
      ),
    );
  }
}
