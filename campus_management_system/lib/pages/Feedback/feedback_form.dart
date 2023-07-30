import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

class FeedbackForm extends StatefulWidget {
  String id;

  FeedbackForm({super.key, required this.id});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  _FeedbackFormState() {
    _selectedFeedbackType = _type[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController describeFeedbackController =
      TextEditingController();
  final TextEditingController supportingEvidenceController =
      TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final String status = "Waiting the Management Review";

  Timestamp timestamp = Timestamp.now();
  DateTime now = DateTime.now();

  final _type = [
    'Academic-related issue',
    'Residential facilities concern',
    'Staff or resident behavior',
    'Safety and security concern'
  ];

  String? _selectedFeedbackType = "";

  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    getdatafromDB() async {
      final user = widget.id;

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
            if (snapshot.connectionState == ConnectionState.waiting) {
              List<String> dataList = snapshot.data as List<String>;
              String name = dataList[0];
              String email = dataList[1];
              String id = dataList[2];

              nameController.text = name;
              emailController.text = email;
              idController.text = id;
              return CircularProgressIndicator();

              // or any loading indicator
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred while loading data'),
              );
            } else {
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
                        'Feedback',
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
                              enabled: false,
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
                              enabled: false,
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
                              enabled: false,
                              decoration: InputDecoration(labelText: 'ID'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your ID';
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
                              value: _selectedFeedbackType,
                              items: _type
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedFeedbackType = val as String;
                                });
                              },
                            ),
                            TextFormField(
                              controller: describeFeedbackController,
                              decoration: InputDecoration(
                                  labelText: 'Describe of feedback'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your describe of feedback';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: supportingEvidenceController,
                              decoration: InputDecoration(
                                labelText:
                                    'Supporting Evidence (if applicable):',
                              ),
                              validator: (value) {
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    'I have read and agree to Terms of Service and Privacy Policy',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 35, 109, 193),
                                    ),
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
                                child: Text('Submit'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  studentResidentApplication(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;
      String formattedTimeStamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await FirebaseFirestore.instance.collection('feedback').doc().set({
        "name": nameController.text,
        "email": emailController.text,
        "id": auth,
        "feedback_type": _selectedFeedbackType,
        "describe_feedback": describeFeedbackController.text,
        "supporting_evidence": supportingEvidenceController.text,
        "status": status,
        "timestamp": formattedTimeStamp,
        "isFavourite": false
      });
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }

  void _confirmDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: Text('This will send the feedback to management '),
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
}
