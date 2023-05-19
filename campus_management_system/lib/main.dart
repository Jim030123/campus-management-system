import 'package:campus_management_system/pages/auth_page.dart';
import 'package:campus_management_system/pages/hostel_student.dart';
import 'package:campus_management_system/pages/test_page.dart';
import 'package:campus_management_system/pages/visitor_page.dart';
import 'package:campus_management_system/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp.router(routerConfig: router));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HostelStudentPage(),
      theme: ThemeData(
          textTheme:
              GoogleFonts.francoisOneTextTheme(Theme.of(context).textTheme)),
    );
  }
}
