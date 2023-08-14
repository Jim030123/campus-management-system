import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_appbar.dart';
import '../../components/my_long_button.dart';

class BookingMenuManagementPage extends StatelessWidget {
  const BookingMenuManagementPage({super.key});

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
            MyIconTile(iconnumber: 0xf01c8, text: 'Facility'),
            SizedBox(
              height: 25,
            ),
            MyLongButton(
              text: 'Facility Reservation',
              routename: '/facility_management',
            ),
            SizedBox(
              height: 25,
            ),
            MyLongButton(
              text: 'Facility Scanner',
              routename: '/facility_scan',
            ),
          ]),
        ),
      ),
    );
  }
}
