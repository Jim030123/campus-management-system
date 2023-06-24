import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../documentation/term_and_condition.dart';

class PersonalForm extends StatefulWidget {
  PersonalForm({
    super.key,
  });

  @override
  _PersonalFormState createState() => _PersonalFormState();
}

class _PersonalFormState extends State<PersonalForm> {
  _PersonalFormState() {
    _selectedNationality = _nationaltype[0];
    _selectedState = _state[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nricController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController homeaddressController = TextEditingController();

  final fulldetail = '1';

  final _nationaltype = ['National Resident', 'Foreign Resident'];
  final _state = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terrengganu'
  ];

  String? _selectedNationality = "";
  String? _selectedState = "";
  bool checkboxValue = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    getdatafromDB() async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(uid) // Use the provided document ID
          .get();
      String role = await snapshot.get('roles');
      String name = await snapshot.get('name');
      String email = await snapshot.get('email');
      String id = await snapshot.get('id');
      String gender = await snapshot.get('gender');
      String nric = await snapshot.get("nric");
      String dob = await snapshot.get("dob");

      return [name, gender, dob, nric, email, role, id];
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            List<String> basicProfileDetail = snapshot.data as List<String>;
            String name = basicProfileDetail[0];
            String gender = basicProfileDetail[1];
            String dob = basicProfileDetail[2];
            String nric = basicProfileDetail[3];
            String email = basicProfileDetail[4];

            String role = basicProfileDetail[5];
            String id = basicProfileDetail[6];

            nameController.text = name;
            genderController.text = gender;
            dobController.text = dob;
            nricController.text = nric;
            emailController.text = email;
            idController.text = id;
            roleController.text = role;
            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Personal Form',
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
                            controller: dobController,
                            decoration:
                                InputDecoration(labelText: 'Date of Birth'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            enabled: false,
                            controller: nricController,
                            decoration: InputDecoration(
                              labelText: 'NRIC',
                            ),
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: roleController,
                            decoration: InputDecoration(labelText: 'Role'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: false,
                            controller: idController,
                            decoration: InputDecoration(labelText: 'ID'),
                            validator: (value) {
                              return null;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Nationality",
                              prefixIcon: Icon(Icons.flag_rounded),
                              border: UnderlineInputBorder(),
                            ),
                            value: _selectedNationality,
                            items: _nationaltype
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedNationality = val as String;
                              });
                            },
                          ),
                          nationalitydropdownlist(),
                          TextFormField(
                            controller: homeaddressController,
                            decoration:
                                InputDecoration(labelText: 'Home Address'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your home address';
                              }
                              return null;
                            },
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Text(
                                            'I agree all Term & Condition'))
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
                                        updatePersonalInfo(context);
                                        // _confirmDialog();
                                      }
                                    }
                                  : null,
                              child: Text('Update'),
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

  nationalitydropdownlist() {
    if (_selectedNationality == _nationaltype[0]) {
      return Column(
        children: [
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "State",
              border: UnderlineInputBorder(),
            ),
            value: _selectedState,
            items: _state
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                _selectedState = val as String;
              });
            },
          ),
          
          TextFormField(
            controller: homeaddressController,
            decoration: InputDecoration(labelText: 'Home Address'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your home address';
              }
              return null;
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  updatePersonalInfo(BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({"address": homeaddressController.text});
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    } // Handle the exception if needed
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service and Privacy Policy'),
          content: ProfileDetailTnC(),
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





//   void _confirmDialog() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Send Feedback'),
//           content: Text('This will send the feedback to management '),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
