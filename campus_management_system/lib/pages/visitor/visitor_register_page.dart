import 'package:campus_management_system/components/my_logo.dart';
import 'package:flutter/material.dart';

import '../../components/my_button.dart';
import '../../components/sample_my_textfield.dart';

class VisitorRegisterPage extends StatelessWidget {
  const VisitorRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmpasswordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(children: [
                MyLogo(),
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
                        controller: _phoneController,
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
                        onTap: () {},
                        text: 'Sign Up',
                      ),
                    ]))
              ])),
        ),
      ),
    );
  }
}
