import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_appbar.dart';
import '../../components/my_long_button.dart';

class AccountManagementMenuPage extends StatelessWidget {
  const AccountManagementMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyManagementDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf7c5, text: 'Account Management'),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
            child: Container(
              child: Align(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Add Account',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  alignment: AlignmentDirectional.center),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/registeration', (route) => false);
            },
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'View All account',
            routename: '/view_all_account',
          ),
        ]),
      ),
    );
  }
}
