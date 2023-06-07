import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Campus Management System'),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, "/login");
          },
        )
      ],
      backgroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
