import 'package:campus_management_system/components/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../documentation/term_and_condition.dart';

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
  final TextEditingController genderController = TextEditingController();
  final TextEditingController studentidController = TextEditingController();
  final TextEditingController parentnameController = TextEditingController();
  final TextEditingController parentcontactnoController =
      TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController parentemailController = TextEditingController();
  final String status = "Waiting the Management Review";
  final String roomno = "";
  final String roombedno = "";
  final _roomtype = [
    'Twin Sharing (Air Conditioned) (Block A & C)',
    'Twin Sharing (Non Air Conditioned) (Block B & D)',
    'Twin Sharing (Air Conditioned) (Block E)',
    'Trio Sharing (Air Conditioned) (Block E)'
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
      String gender = await snapshot.get('gender');
      String parentname = await snapshot.get('parent_name');
      String parentcontanctno = await snapshot.get('parent_contact_no');
      String parentemail = await snapshot.get('parent_email');
      String relationship = await snapshot.get('relationship');

      return [
        name,
        gender,
        email,
        id,
        parentname,
        parentcontanctno,
        parentemail,
        relationship
      ];
    }

    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            List<String> dataList = snapshot.data as List<String>;
            String name = dataList[0];
            String gender = dataList[1];
            String email = dataList[2];
            String id = dataList[3];
            String parentname = dataList[4];
            String parentcontanctno = dataList[5];
            String parentemail = dataList[6];
            String relationship = dataList[7];

            nameController.text = name;
            genderController.text = gender;
            emailController.text = email;
            studentidController.text = id;
            parentnameController.text = parentname;
            parentcontactnoController.text = parentcontanctno;
            parentemailController.text = parentemail;
            relationshipController.text = relationship;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Display circular progress indicator while data is loading
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'), // Display error message
              );
            }
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
                            enabled: false,
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
                            enabled: false,
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
                            enabled: false,
                            controller: genderController,
                            decoration: InputDecoration(labelText: 'Gender'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: studentidController,
                            decoration: InputDecoration(labelText: 'ID'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: parentnameController,
                            decoration:
                                InputDecoration(labelText: 'Parent Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Parent Name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: relationshipController,
                            decoration:
                                InputDecoration(labelText: 'Relationship'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: parentcontactnoController,
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
                          TextFormField(
                            enabled: false,
                            controller: parentemailController,
                            decoration:
                                InputDecoration(labelText: 'Parent Email'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Room Type",
                              prefixIcon: Icon(Icons.bed_rounded),
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
                            isExpanded: true,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showAlertDialog();
                                },
                                child: Row(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        "I have read and agree to Terms of Service and Privacy Policy",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 35, 109, 193),
                                        ),
                                      ),
                                    ),
                                  ],
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
        "gender": genderController.text,
        "user_id": studentidController.text,
        "parent_name": parentnameController.text,
        "relationship": relationshipController.text,
        "parent_contact_no": parentcontactnoController.text,
        "parent_email": parentemailController.text,
        "room_type": _selectedRoomType as String,
        "status": status,
        "room_no": roomno,
        "room_bed_no": roombedno,
        "id": auth
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
          title: Text('Submit your student resident application'),
          content: Text(
            'This will also sent the student resident application to management review',
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service and Privacy Policy'),
          content: SingleChildScrollView(child: StudentResidentTnC()),
          actions: [
            TextButton(
              child: Text('Close'),
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
