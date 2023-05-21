import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/hostel_student.dart';
import 'package:campus_management_system/pages/management_page.dart';
import 'package:campus_management_system/pages/register_hostel_student.dart';
import 'package:campus_management_system/pages/management_register_page.dart';
import 'package:campus_management_system/pages/test_page.dart';
import 'package:campus_management_system/pages/visitor_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => MyTestPage()),
  // GoRoute(path: '/hostel_student, builder: (context, state) => HostelStudentPage()),
  GoRoute(path: '/management', builder: (context, state) => ManagementPage()),
  GoRoute(path: '/visitor', builder: (context, state) => VisitorPage())
]);
