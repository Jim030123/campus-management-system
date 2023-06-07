import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../components/my_appbar.dart';
import '../components/my_long_button.dart';

class SecurityMenuPage extends StatelessWidget {
  const SecurityMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf013e, text: 'Security'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Register Vehicle',
            routename: '/register_vehicle',
          ),
          SizedBox(
            height: 25,
          ),
          
          MyLongButton(
            text: 'Show Vechicle Registered',
            routename: '/show_registered_car',
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Entry Record (Comming Soon)',
            routename: '',
          ),
        ]),
      ),
    );
  }
}
