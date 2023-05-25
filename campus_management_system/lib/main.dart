import 'package:campus_management_system/components/my_curved_navigation.dart';
import 'package:campus_management_system/pages/main_page.dart';
import 'package:campus_management_system/pages/auth_page.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/introduction_page.dart';
import 'package:campus_management_system/pages/login_page.dart';
import 'package:campus_management_system/pages/management_register_page.dart';
import 'package:campus_management_system/pages/sample_login_page.dart';
import 'package:campus_management_system/pages/test_page.dart';
import 'package:campus_management_system/pages/visitor_page.dart';
import 'package:campus_management_system/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => IntroductionPage(),
        '/sample_home': (context) => RegistrationPage(),
        '/main': (context) => MainPage(),
        '/auth': (context) => AuthPage(),
        '/login': (context) => MyLoginPage(),
        '/test': (context) => MyTestPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: true,
      // home: AuthPage(),
      theme: ThemeData(
          textTheme:
              GoogleFonts.francoisOneTextTheme(Theme.of(context).textTheme)),
    );
  }
}
