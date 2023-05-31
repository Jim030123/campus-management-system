import 'package:campus_management_system/components/my_drawer_listtile.dart';
import 'package:campus_management_system/components/my_long_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

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
                pagename: 'Main Page', routename: '/main', icon: 0xe038),
            MyDrawerListtile(
                pagename: 'pagename', routename: '/', icon: 0xe038),
            MyDrawerListtile(
                pagename: 'pagename', routename: '/', icon: 0xe038),
            MyDrawerListtile(
                pagename: 'pagename', routename: '/', icon: 0xe038),
            MyDrawerListtile(
                pagename: 'pagename', routename: '/', icon: 0xe038),
            MyDrawerListtile(
                pagename: 'pagename', routename: '/', icon: 0xe038),
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                MyLongButton(
                  text: 'Log out',
                  routename: '',
                ),

                SizedBox(
                  height: 25,
                ),

                // ElevatedButton(
                //   onPressed: () {},
                //   child: Text('ji'),
                // ),
                // ElevatedButton(onPressed: () {}, child: Text('ji'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
