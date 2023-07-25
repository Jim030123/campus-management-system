import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/my_button.dart';

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
  final _formKey = GlobalKey<FormState>();

  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Password don\'t match!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    child: Text('If you have account, login Here '),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                MyLogo(),
                SizedBox(height: 25),
                Container(
                  width: 300,
                  child: Column(
                    children: [
                      Text(
                        'Visitor Register Page',
                        style: TextStyle(fontSize: 30),
                      ),
                      MyDivider(),
                      SizedBox(height: 25),
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(labelText: 'Name'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Name!';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 25),
                              TextFormField(
                                controller: _contactnumberController,
                                decoration: InputDecoration(
                                    labelText: 'Contact Number'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter Contact Number!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 25),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Email!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 25),
                              // password
                              TextFormField(
                                controller: _passwordController,
                                decoration:
                                    InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return 'Please enter at least 6 character Password!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 25),
                              // confirm password
                              TextFormField(
                                controller: _confirmpasswordController,
                                decoration: InputDecoration(
                                    labelText: 'Confirm Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return 'Please enter at least 6 character Password!';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 100),
                              MyButton(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    signUpWithEmail(context);
                                    popoutdialog();
                                  }
                                },
                                text: 'Sign Up',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUpWithEmail(BuildContext context) async {
    if (_passwordController.text == _confirmpasswordController.text) {
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
          "full_detail": fullDetail,
        });
      } on FirebaseAuthException catch (e) {}
      

      Navigator.pushNamedAndRemoveUntil(context, '', (route) => false);
    } else {
      showErrorMessage();
    }
  }

  popoutdialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register your visitor account...'),
          content: Text('You should be redirected automatically in 3 second'),
        );
      },
    );
  }
}
