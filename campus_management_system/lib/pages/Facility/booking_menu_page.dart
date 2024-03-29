import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_appbar.dart';
import '../../components/my_long_button.dart';

class BookingMenuPage extends StatelessWidget {
  const BookingMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyStudentDrawer(),
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
              text: 'Booking and Facility Information',
              routename: '/facility_information',
            ),
            SizedBox(
              height: 25,
            ),
            MyLongButton(
              text: 'Booking Facility History',
              routename: '/booking_history',
            ),
            SizedBox(
              height: 25,
            ),
            MyLongButton(
              text: 'Check facility available',
              routename: '/check_facility_available',
            ),
          ]),
        ),
      ),
    );
  }
}
