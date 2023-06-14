import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/role.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

class ResidentApplicationPage extends StatefulWidget {
  ResidentApplicationPage({super.key});

  @override
  _ResidentApplicationPageState createState() =>
      _ResidentApplicationPageState();
}

class _ResidentApplicationPageState extends State<ResidentApplicationPage> {
  _ResidentApplicationPageState() {
    _selectedRoomType = _roomtype[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController parentNameController = TextEditingController();
  final TextEditingController parentContactNoController =
      TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final String status = "Wait the Management Review";

  final _roomtype = [
    'Twin Sharing (Air Conditioned) (Block A & C) RM 660 (Short Semester) RM 990 (Long Semester)',
    'Twin Sharing (Non Air Conditioned) (Block B & D) RM 840 (Short Semester) RM 1 260 (Long Semester)',
    'Twin Sharing (Air Conditioned) (Block E) RM 1 500 (Short Semester)  RM 2 250 (Long Semester)',
    'Trio Sharing (Air Conditioned) (Block E) RM 1 050 (Short Semester)  RM 1 575 (Long Semester)'
  ];

  String? _selectedRoomType = "";

  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    getdatafromDB() async {
      final user = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(user) // Use the provided document ID
          .get();

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

            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Student Resident Application',
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
                          TextFormField(
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
                            controller: idController,
                            decoration: InputDecoration(labelText: 'ID'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Role",
                              prefixIcon: Icon(Icons.verified_user),
                              border: UnderlineInputBorder(),
                            ),
                            value: _selectedRoomType,
                            items: _roomtype
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedRoomType = val as String;
                              });
                            },
                          ),
                          TextFormField(
                            controller: parentNameController,
                            decoration:
                                InputDecoration(labelText: 'Parent Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Parent Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: parentContactNoController,
                            decoration: InputDecoration(
                              labelText: 'Parent Contact Number',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Parent Contact Number';
                              }
                              return null;
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
                              Text(
                                "I have read and agree to Terms of Service and Privacy Policy",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 33, 40, 243),
                                ),
                              ),
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
                                        studentResidentApplication(context);
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

  studentResidentApplication(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(auth)
          .set({
        "name": nameController.text,
        "email": emailController.text,
        "id": idController.text,
        "room_type": _selectedRoomType,
        "parent_name": parentNameController.text,
        "parent_contact_no": parentContactNoController.text,
        "status": status,
      });
      print(auth);
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }

  void _confirmDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create account'),
          content: Text(
            'This will also create a profile for ' + emailController.text,
          ),
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
  }
}
