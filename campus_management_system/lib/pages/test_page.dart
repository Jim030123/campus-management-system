import "package:campus_management_system/components/my_drawer.dart";
import "package:campus_management_system/components/my_listtile.dart";
import "package:campus_management_system/components/my_switchlisttile.dart";
import "package:campus_management_system/components/my_tile.dart";
import "package:campus_management_system/pages/main_page.dart";
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import 'package:firebase_auth/firebase_auth.dart';
import '../components/sample_my_textfield_copy.dart';
import "../components/sample_my_textfield.dart";

class MyTestPage extends StatelessWidget {
  MyTestPage({super.key});

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrImageView(
        data: user.uid,
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }
}
