import 'package:flutter/material.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
 

  const MyAppBar({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Campus Management System'),
     backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}