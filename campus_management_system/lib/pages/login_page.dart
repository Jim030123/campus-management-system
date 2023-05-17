import 'package:campus_management_system/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
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
            
            const SizedBox(
              height: 25,
            ),

            // password
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obsecureText: true,
            ),

            const SizedBox(
              height: 10,
            ),

            // forgot password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25.0,)
          ]),
        ),
      ),
    );
  }
}
