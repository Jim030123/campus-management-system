import 'package:campus_management_system/components/my_drawer_listtile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyStudentDrawer extends StatelessWidget {
  MyStudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: StreamBuilder<DateTime>(
        stream: _dateTimeStream(),
        initialData: DateTime.now(),
        builder: (context, snapshot) {
          String formattedDate = DateFormat('\n kk:mm:ss \n EEE d MMM')
              .format(snapshot.data ?? DateTime.now());

          return Container(
            child: ListView(
              children: [
                Center(
                  child: Text(
                    "Last Updated Time: $formattedDate",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DrawerHeader(
                  child: Image.asset(
                    'lib/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
                MyDrawerListtile(
                    pagename: 'Main Page',
                    routename: '/student_main_page',
                    icon: 0xe328),
                MyDrawerListtile(
                    pagename: 'Profile', routename: '/profile', icon: 0xf522),
                MyDrawerListtile(
                    pagename: 'Security',
                    routename: '/security_menu',
                    icon: 0xf013e),
                MyDrawerListtile(
                    pagename: 'Feedback',
                    routename: '/feedback_menu',
                    icon: 0xf73b),
                MyDrawerListtile(
                    pagename: 'Facility',
                    routename: '/facility_menu',
                    icon: 0xf01c8),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Stream<DateTime> _dateTimeStream() {
    return Stream<DateTime>.periodic(
        const Duration(seconds: 1), (_) => DateTime.now());
  }
}

class MyManagementDrawer extends StatelessWidget {
  MyManagementDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: StreamBuilder<DateTime>(
        stream: _dateTimeStream(),
        initialData: DateTime.now(),
        builder: (context, snapshot) {
          String formattedDate = DateFormat('\n kk:mm:ss \n EEE d MMM')
              .format(snapshot.data ?? DateTime.now());

          return Container(
            child: ListView(
              children: [
                Center(
                  child: Text(
                    "Last Updated Time: $formattedDate",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                DrawerHeader(
                  child: Image.asset(
                    'lib/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Divider(
                  height: 2.0,
                  color: Colors.black,
                ),
                MyDrawerListtile(
                    pagename: 'Main Page',
                    routename: '/management_main',
                    icon: 0xe328),
                MyDrawerListtile(
                    pagename: 'Management Profile',
                    routename: '/profile',
                    icon: 0xf522),
                MyDrawerListtile(
                    pagename: 'Security Management',
                    routename: '/security_management_menu',
                    icon: 0xf013e),
                MyDrawerListtile(
                    pagename: 'Feedback Received',
                    routename: '/feedback_received',
                    icon: 0xf73b),
                MyDrawerListtile(
                    pagename: 'Student Resident Management',
                    routename: '/student_resident_management_menu',
                    icon: 0xe481),
                MyDrawerListtile(
                    pagename: 'Facility Management',
                    routename: '/facility_management_menu',
                    icon: 0xf01c8),
                SizedBox(height: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Stream<DateTime> _dateTimeStream() {
    return Stream<DateTime>.periodic(
        const Duration(seconds: 1), (_) => DateTime.now());
  }
}
