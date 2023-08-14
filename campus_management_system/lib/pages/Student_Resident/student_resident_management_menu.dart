import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';
import '../../components/my_long_button.dart';

class StudentResidentManagementMenu extends StatelessWidget {
  const StudentResidentManagementMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyManagementDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf0110, text: 'Student Resident Management'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Student Resident Application',
            routename: '/student_resident_application',
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Room Availability',
            routename: '/room_available',
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Add Room',
            routename: '/add_room',
          ),
        ]),
      ),
    );
  }
}
