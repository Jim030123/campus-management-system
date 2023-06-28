import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/role.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

import '../components/my_camera.dart';

class RegistrationVehiclePage extends StatefulWidget {
  final String id;

  RegistrationVehiclePage({super.key, required this.id});

  @override
  _RegistrationVehiclePageState createState() =>
      _RegistrationVehiclePageState();
}

class _RegistrationVehiclePageState extends State<RegistrationVehiclePage> {
  @override
  _RegistrationVehiclePageState() {}

  final _formKey = GlobalKey<FormState>();

  final TextEditingController vehiclenumberController = TextEditingController();
  final TextEditingController modelnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  final String status = "Waiting the Management Review";

  bool checkboxValue = false;

  bool value = false;

  @override
  Widget build(BuildContext context) {
    getdatafromDB() async {
      final user = widget.id;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(user) // Use the provided document ID
          .get();

      // Access the "role" field and convert it to a string

      String name = await snapshot.get('name');
      String email = await snapshot.get('email');
      String id = await snapshot.get('id');
      return [name, email, id];
    }

    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            List<String> dataList = snapshot.data as List<String>;
            String name = dataList[0];

            String email = dataList[1];

            String id = dataList[2];

            nameController.text = name;
            emailController.text = email;
            idController.text = id;

            final XFile? picture;
            return Container(
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
                            // readOnly: true,
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
                            // readOnly: true,
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
                            // readOnly: true,
                            controller: idController,
                            decoration: InputDecoration(labelText: 'ID'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: vehiclenumberController,
                            decoration: InputDecoration(
                                labelText: 'Vehicle Plate Number'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Vechicle Plate Number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: modelnameController,
                            decoration: InputDecoration(
                                labelText: 'Vehicle Model Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Vechicle Model Name';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.0),

                          ElevatedButton(
                            child: Text('Take Photo'),
                            onPressed: () async {
                              await availableCameras().then((value) =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CameraPage(cameras: value))));
                            },
                          ),

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
                              Container(
                                
                                child: Text(
                                    "I have read and agree to Terms of Service and Privacy Policy"),
                              )
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
                                        registerVehicle(context);
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
            );
          },
        ),
      ),
    );
  }

  registerVehicle(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth)
          .collection('vehicle')
          .doc(vehiclenumberController.text)
          .set({
        "name": nameController.text,
        "email": emailController.text,
        "id": idController.text,
        "vehicle_number": vehiclenumberController.text,
        "model": modelnameController.text,
        "status": status
      });
      print(auth);
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
