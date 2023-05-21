import 'package:campus_management_system/components/my_button.dart';
import 'package:campus_management_system/components/my_button2.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:campus_management_system/pages/home_page.dart';
import 'package:campus_management_system/pages/management_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../components/sample_my_textfield.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
<<<<<<< Updated upstream
      


=======
      GoRouter.of(context).go("/home_page");
>>>>>>> Stashed changes
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      }
    }

    // pop the loading circle
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.grey[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // column child

          children: [
            SizedBox(
              height: 70.0,
            ),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('Switch to Visitor'),
                onPressed: () {
                  print('Hello');
                },
              ),
            ),

            SizedBox(
              height: 50.0,
            ),
            // Allign center
            MyLogo(),

            SizedBox(
              height: 25.0,
            ),

            Container(
              // color: Colors.red,
              width: 300,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SampleTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obsecureText: false,
                  ),
                  SampleTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obsecureText: true,
                  ),
                  MyButton(onTap: signUserIn, text: 'Log In'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Incorrect Email'),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Incorrect Password'),
          );
        });
  }
}
