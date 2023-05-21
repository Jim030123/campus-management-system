import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        GoRouter.of(context).go(routename);
      },
    );
  }
}
