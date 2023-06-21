import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_icon_tile.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/my_appbar.dart';
import '../../components/my_long_button.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Container(
        color: Colors.white,
        child: Column(children: [
          MyLogo(),
          MyIconTile(iconnumber: 0xf73b, text: 'Feedback'),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Fill Feedback',
            routename: '/feedback_form',
          ),
          SizedBox(
            height: 25,
          ),
          MyLongButton(
            text: 'Feedback Submitted',
            routename: '/feedback_submitted',
          ),
        ]),
      ),
    );
  }
}
