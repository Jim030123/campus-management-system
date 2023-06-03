import 'package:flutter/material.dart';

class LoginSuccessfulPage extends StatefulWidget {
  @override
  _LoginSuccessfulPageState createState() => _LoginSuccessfulPageState();
}

class _LoginSuccessfulPageState extends State<LoginSuccessfulPage> {
  @override
  void initState() {
    super.initState();
    // Programmatically navigate to the second page after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/student_main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: Text('Redirecting to the second page...'),
      ),
    );
  }
}
  
