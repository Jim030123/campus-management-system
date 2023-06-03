import 'package:campus_management_system/pages/account_management_page.dart';
import 'package:campus_management_system/pages/auth_page.dart';
import 'package:campus_management_system/pages/facility_information.dart';
import 'package:campus_management_system/pages/redirect_login_page.dart';
import 'package:campus_management_system/pages/booking_menu_page.dart';
import 'package:campus_management_system/pages/booking_page.dart';
import 'package:campus_management_system/pages/feedback_menu_page.dart';

import 'package:campus_management_system/pages/resident_menu_page.dart';
import 'package:campus_management_system/pages/main_page.dart';

import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/introduction_page.dart';
import 'package:campus_management_system/pages/login_page.dart';
import 'package:campus_management_system/pages/management_register_page.dart';
import 'package:campus_management_system/pages/profile_page.dart';
import 'package:campus_management_system/pages/security_menu.dart';
import 'package:campus_management_system/pages/show_car_registered.dart';
import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/pages/test.dart';
import 'package:campus_management_system/pages/view_all_account.dart';
import 'package:campus_management_system/pages/visitor_page.dart';
import 'package:campus_management_system/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:booking_calendar/booking_calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  get refreshedUser => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorObservers: [routeObserver],
      routes: {
        '': (context) => RedirectLoginPage(),
        '/': (context) => IntroductionPage(),
        '/student_main': (context) => StudentMainPage(),
        '/auth': (context) => AuthPage(),
        '/login': (context) => MyLoginPage(),
        '/test': (context) => MyTestPage(),
        '/profile': (context) => ProfilePage(),
        '/logout': (context) => MyLoginPage(),

        // Menu
        '/resident_menu': (context) => StudentResidentMenuPage(),
        '/feedback_menu': (context) => FeedbackPage(),

        // Security
        '/security_menu': (context) => SecurityMenuPage(),
        '/show_registered_car': (context) => ShowRegisterdCarPage(),

        // Facility
        '/facility_menu': (context) => BookingMenuPage(),
        '/facility_information': (context) => FacilityInformationPage(),
        '/booking_page': (context) => BookingPage(),

        // Management
        '/account_management_menu': (context) => AccountManagementMenuPage(),
        '/registeration': (context) => RegistrationPage(),
        '/view_all_account': (context) => ViewAllAccountPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: true,
      // home: AuthPage(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.black),
          textTheme:
              GoogleFonts.francoisOneTextTheme(Theme.of(context).textTheme)),
    );
  }
}
