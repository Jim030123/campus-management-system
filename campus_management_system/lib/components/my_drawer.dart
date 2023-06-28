import 'package:campus_management_system/components/my_drawer_listtile.dart';
import 'package:campus_management_system/components/my_long_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyStudentDrawer extends StatelessWidget {
  MyStudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('\n kk:mm:ss \n EEE d MMM').format(now);

    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: Container(
        child: ListView(
          children: [
            Center(
                child: Text(
              "Last Updated Time:" + formattedDate,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )),
            DrawerHeader(
                child: Image.asset(
              'lib/images/logo.png',
              width: 100,
              height: 100,
            )),
            Divider(
              height: 2.0,
              color: Colors.black,
            ),
            MyDrawerListtile(
                pagename: 'Main Page', routename: '/main', icon: 0xe328),
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
                pagename: 'Billing (havent done)',
                routename: '/facility_menu',
                icon: 0xe481),
            MyDrawerListtile(
                pagename: 'Facility (Done)',
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
      ),
    );
  }
}

class MyManagementDrawer extends StatelessWidget {
  MyManagementDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('\n kk:mm:ss \n EEE d MMM').format(now);

    return Drawer(
      backgroundColor: Colors.blueGrey,
      child: Container(
        child: ListView(
          children: [
            Center(
                child: Text(
              "Last Updated Time:" + formattedDate,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )),
            DrawerHeader(
                child: Image.asset(
              'lib/images/logo.png',
              width: 100,
              height: 100,
            )),
            Divider(
              height: 2.0,
              color: Colors.black,
            ),
            MyDrawerListtile(
                pagename: 'Main Page', routename: '/main', icon: 0xe328),
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
                pagename: 'Billing (havent done)',
                routename: '/facility_menu',
                icon: 0xe481),
            MyDrawerListtile(
                pagename: 'Facility (Done)',
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
      ),
    );
  }
}
