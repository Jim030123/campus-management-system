import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionPage extends StatelessWidget {
  IntroductionPage({super.key});

  List<PageViewModel> listViewModel = [
    PageViewModel(
      title: 'Welcome To Southern University College Campus Management System',
      body:
          'A campus management system is a powerful software solution designed to streamline and enhance various administrative and operational processes within an educational institution.',
      image: Center(
        child: Image.asset('lib/images/logo.png'),
      ),
    ),
    PageViewModel(
      title: 'For Management',
      body:
          'Students can submit online applications for hostel accommodation, provide their preferences, and view the availability of rooms. Administrators can then process these applications, allocate rooms based on various criteria such as gender, year of study, and preferences, and communicate the results to the students.',
      image: Center(
        child: Image.asset('lib/images/office_management.jpg'),
      ),
    ),
    PageViewModel(
      title: 'For Hostel Student',
      body:
          'Hostel students can submit online applications for hostel accommodation and view the availability of rooms.',
      image: Center(
        child: Image.asset('lib/images/hostel_student.jpg'),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: listViewModel,
        done: const Text('Let\'s GO'),
        onDone: () {
          Navigator.pushNamed(context, '/auth');
        },
        showNextButton: false,
      ),
    );
  }
}
