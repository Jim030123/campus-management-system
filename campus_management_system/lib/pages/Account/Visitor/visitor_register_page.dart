import 'package:campus_management_system/components/my_logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/my_button.dart';
import '../../../components/sample_my_textfield.dart';

final _emailController = TextEditingController();
final _nameController = TextEditingController();
final _contactnumberController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmpasswordController = TextEditingController();
final String role = "Visitor";
String fullDetail = "0";

class VisitorRegisterPage extends StatefulWidget {
  VisitorRegisterPage({super.key});

  @override
  State<VisitorRegisterPage> createState() => _VisitorRegisterPageState();
}

class _VisitorRegisterPageState extends State<VisitorRegisterPage> {
  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // check if password is confirmed
      if (_passwordController.text == _confirmpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } else {
        showErrorMessage();
      }

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String role = "Visitor";

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(children: [
                MyLogo(),
                SizedBox(
                  height: 25,
                ),
                Container(
                    width: 300,
                    child: Column(children: [
                      Text(
                        'Visitor Register Page',
                        style: TextStyle(fontSize: 30),
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      SampleTextField(
                        controller: _nameController,
                        hintText: 'Name',
                        obsecureText: false,
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      SampleTextField(
                        controller: _contactnumberController,
                        hintText: 'Phone',
                        obsecureText: false,
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      SampleTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        obsecureText: false,
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      // password
                      SampleTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obsecureText: true,
                      ),

                      const SizedBox(
                        height: 25,
                      ),

                      // confirm password
                      SampleTextField(
                        controller: _confirmpasswordController,
                        hintText: 'Confirm Password',
                        obsecureText: true,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      MyButton(
                        onTap: () {
                          signUpWithEmail(context);
                          Navigator.pushReplacementNamed(
                              context, '/visitor_main');
                        },
                        text: 'Sign Up',
                      ),
                    ]))
              ])),
        ),
      ),
    );
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

  void showErrorMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Password don\'t match!'),
          );
        });
  }
  // pop the loading circle
}

Future<void> signUpWithEmail(BuildContext context) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    String uid = userCredential.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      "name": _nameController.text,
      "contact_no": _contactnumberController.text,
      "email": _emailController.text,
      "roles": role,
      "full_detail": fullDetail
    });

    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text);
  } on FirebaseAuthException catch (e) {}
  ;
  // pop the loading circle
}
