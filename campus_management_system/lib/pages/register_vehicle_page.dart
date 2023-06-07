import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/role.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

class RegistrationVehiclePage extends StatefulWidget {
  @override
  _RegistrationVehiclePageState createState() =>
      _RegistrationVehiclePageState();
}

class _RegistrationVehiclePageState extends State<RegistrationVehiclePage> {
  @override
  _RegistrationVehiclePageState() {
    _selectedRole = _roles[0];
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController vehiclenumberController = TextEditingController();
  final TextEditingController modelnameController = TextEditingController();

  final _roles = ['Resident_Student', 'Management', 'Visitor'];
  DateTime dob = DateTime.now();
  bool checkboxValue = false;
  String? _selectedRole = "";
  String? _selectedProgram = "";
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Register New Car',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name
                      TextFormField(
                        readOnly: true,
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        readOnly: true,
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Email';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: vehiclenumberController,
                        decoration:
                            InputDecoration(labelText: 'Vehicle Plate Number'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Vechicle Plate Number';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: modelnameController,
                        decoration:
                            InputDecoration(labelText: 'Vehicle Model Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Vechicle Model Name';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.0),

                      Row(
                        children: [
                          Checkbox(
                            value: checkboxValue,
                            onChanged: (bool? value) {
                              setState(() {
                                checkboxValue = value ?? false;
                              });
                            },
                          ),
                          Text(
                              "I have read and agree to Terms of Service and Privacy Policy")
                        ],
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: checkboxValue
                              ? () {
                                  if (_formKey.currentState!.validate()) {
                                    signUpWithEmail(context);
                                    _confirmDialog();
                                  }
                                }
                              : null,
                          child: Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpWithEmail(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;

      String formattedDob = DateFormat('yyyy/MM/dd').format(dob);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth)
          .collection('vehicle')
          .doc(vehiclenumberController.text)
          .set({
        "name": nameController.text,
        "dob": formattedDob,
        "email": emailController.text,
        "id": idController.text,
      });

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }

  void _confirmDialog() async {
    // show loading circle

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create account'),
          content: Text(
              'This also will create a profile for' + emailController.text),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );

    // pop the loading circle
  }
}
