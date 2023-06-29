import 'package:campus_management_system/components/my_button.dart';
import 'package:campus_management_system/components/my_button2.dart';
import 'package:campus_management_system/components/my_logo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/sample_my_textfield.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({
    super.key,
  });

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

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
          email: _emailController.text, password: _passwordController.text);
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '', (route) => false);
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
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // column child
                children: [
                  SizedBox(
                    height: 70.0,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      child: Text('If you are visitor, register Here '),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/visitor_register', (route) => false);
                      },
                    ),
                  ),

                  SizedBox(
                    height: 50.0,
                  ),
                  // Allign center
                  Container(child: MyLogo()),

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
                          controller: _emailController,
                          hintText: 'Email',
                          obsecureText: false,
                        ),
                        SampleTextField(
                          controller: _passwordController,
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
          ),
        ));
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
