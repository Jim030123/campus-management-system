import 'package:campus_management_system/components/textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Welcome back you\'ve been missed',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),

            // username
            MyTextField(
              controller: usernameController,
              hintText: 'Username',
              obsecureText: false,
            ),
            SizedBox(
              height: 25,
            ),

            // password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obsecureText: true,
            ),
          ]),
        ),
      ),
    );
  }
}
