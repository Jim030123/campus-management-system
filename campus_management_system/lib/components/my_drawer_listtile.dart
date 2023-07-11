import 'package:flutter/material.dart';

class MyDrawerListtile extends StatelessWidget {
  const MyDrawerListtile({
    super.key,
    required this.icon,
    required this.pagename,
    required this.routename,
  });

  final String routename;
  final String pagename;
  final int icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(IconData(icon, fontFamily: 'MaterialIcons')),
      title: Text(pagename),
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, routename, (route) => false);
      },
    );
  }
}
