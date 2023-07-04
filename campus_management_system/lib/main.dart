import 'package:campus_management_system/pages/Account/Management/management_main_page.dart';
import 'package:campus_management_system/pages/Account/Visitor/visitor_login.dart';
import 'package:campus_management_system/pages/Account/Visitor/visitor_register_page.dart';
import 'package:campus_management_system/pages/Account/account_management_page.dart';
import 'package:campus_management_system/pages/Feedback/feedback_form.dart';
import 'package:campus_management_system/pages/Feedback/feedback_menu_page.dart';
import 'package:campus_management_system/pages/Feedback/feedback_submitted.dart';
import 'package:campus_management_system/pages/General/auth_page.dart';
import 'package:campus_management_system/pages/Security/register_vehicle_page.dart';
import 'package:campus_management_system/pages/Security/security_menu.dart';
import 'package:campus_management_system/pages/Security/show_car_registered.dart';
import 'package:campus_management_system/pages/Facility/facility_information.dart';
import 'package:campus_management_system/pages/General/personal_form.dart';
import 'package:campus_management_system/pages/Student_Resident/add_room.dart';
import 'package:campus_management_system/pages/Feedback/feedback_received.dart';
import 'package:campus_management_system/pages/Autofill/auto_fill_form_menu.dart';
import 'package:campus_management_system/pages/Student_Resident/room_availble_page.dart';
import 'package:campus_management_system/pages/Student_Resident/student_resident_application.dart';
import 'package:campus_management_system/pages/General/redirect_page.dart';
import 'package:campus_management_system/pages/Facility/booking_menu_page.dart';
import 'package:campus_management_system/pages/Student_Resident/student_resident_exist.dart';
import 'package:campus_management_system/pages/Student_Resident/student_resident_management_menu.dart';
import 'package:campus_management_system/pages/Facility/check_facility_available.dart';
import 'package:campus_management_system/pages/Visitor_Pass/scan.dart';
import 'package:campus_management_system/pages/Visitor_Pass/view_all_visitor_pass.dart';
import 'package:campus_management_system/pages/Visitor_Pass/visitor_pass_application.dart';
import 'package:campus_management_system/pages/Student_Resident/resident_menu_page.dart';
import 'package:campus_management_system/pages/General/introduction_page.dart';
import 'package:campus_management_system/pages/General/login_page.dart';
import 'package:campus_management_system/pages/Account/registration_account.dart';
import 'package:campus_management_system/pages/General/profile_page.dart';
import 'package:campus_management_system/pages/Student_Resident/resident_form.dart';

import 'package:campus_management_system/pages/Student_Resident/resident_information.dart';
import 'package:campus_management_system/pages/Account/Student/student_main_page.dart';
import 'package:campus_management_system/pages/Account/view_all_account.dart';
import 'package:campus_management_system/pages/Visitor_Pass/register_visitor_pass.dart';
import 'package:campus_management_system/pages/Account/Visitor/visitor_main_page.dart';
import 'package:campus_management_system/pages/Visitor_Pass/visitor_pass_management.dart';
import 'package:campus_management_system/pages/Visitor_Pass/visitor_pass_progress.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'documentation/room_type.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  // get refreshedUser => null;

  @override
  Widget build(BuildContext context) {
    String id = FirebaseAuth.instance.currentUser?.uid ?? 'defaultId';

    return MaterialApp(
      routes: {
        // Account
        '/management_main': (context) => ManagementMainPage(),
        '/student_main': (context) => StudentMainPage(),
        '/visitor_login': (context) => VisitorLoginPage(),

        // General
        '/': (context) => IntroductionPage(),

        '/auth': (context) => AuthPage(),
        '/login': (context) => MyLoginPage(),
        '/profile': (context) => ProfilePage(),
        '/logout': (context) => MyLoginPage(),

        '/personal_form': (context) => PersonalForm(),

        // Redirect Page
        '': (context) => RedirectLoginPage(),
        '/redirect_personal_form': (context) => RedirectProfileForm(),
        '/redirect_visitor_personal_form': (context) =>
            RedirectVisitorProfileForm(),

        // Student

        // Student Resident
        '/resident_menu': (context) => StudentResidentMenuPage(),
        '/resident_student': (context) => StudentResidentExist(),
        '/resident_application': (context) => ResidentApplicationPage(id: id),
        '/resident_information': (context) => ResidentInformationPage(),
        '/room_information_A_C': (context) => TwinSharingRoomBlock_A_C(),
        '/room_information_B_D': (context) => TwinSharingRoomBlock_B_D(),
        '/room_information_twin_E': (context) => TwinSharingRoomIEB(),
        '/room_information_trio_E': (context) => TrioSharingRoomIEB(),

        // Feedback
        '/feedback_menu': (context) => FeedbackPage(),
        '/feedback_form': (context) => FeedbackForm(id: id),
        '/feedback_submitted': (context) => FeedbackSubmitted(),
        '/feedback_received': (context) => FeedbackRecieved(),

        // Security
        '/security_menu': (context) => SecurityMenuPage(),
        '/show_registered_car': (context) => ShowRegisterdCarPage(),
        '/register_vehicle': (context) => RegistrationVehicleForm(
              id: id,
            ),

        // Facility
        '/facility_menu': (context) => BookingMenuPage(),
        '/facility_information': (context) => FacilityInformationPage(),
        '/check_facility_available': (context) => CheckFacilityAvailable(),

        // Management
        '/account_management_menu': (context) => AccountManagementMenuPage(),
        '/registeration': (context) => RegistrationAccount(),
        '/view_all_account': (context) => ViewAllAccountPage(),
        '/student_resident_application': (context) =>
            StudentResidentApplicationPage(),
        '/room_available': (context) => RoomAvailable(),
        '/auto_fill_form_menu': (context) => AutoFillFormMenu(),
        '/visitor_pass_application': (context) => VisitorPassApplicationPage(),
        '/add_room': (context) => AddRoomForm(),
        '/student_resident_management_menu': (context) =>
            StudentResidentManagementMenu(),

        // Visitor
        '/visitor_main': (context) => VisitorMainPage(),
        '/register_visitor_pass': (context) => RegisterVisitorPass(
              id: id,
            ),
        '/visitor_pass_management': (context) => VisitorPassManagementMenu(),

        '/visitor_register': (context) => VisitorRegisterPage(),
        '/visitor_pass_progress': (context) => VisitorPassProgress(),
        '/visitor_personal_form': (context) => VisitorPersonalForm(),
        '/visitor_profile_page': (context) => VistitorProfilePage(),
        '/view_all_visitor_pass': (context) => ViewAllVisitorPass(),
        '/visitor_pass_scanner': (context) => VisitorPassScanner(),
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
