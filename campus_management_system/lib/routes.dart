import 'package:campus_management_system/pages/blank_page.dart';
import 'package:campus_management_system/pages/login_page.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => BlankPage()),
]);
