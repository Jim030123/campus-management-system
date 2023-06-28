import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
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
    _selectedRelationship = _relationship[0];
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
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController contactnoController = TextEditingController();
  final TextEditingController foreignCountryController =
      TextEditingController();

  final TextEditingController parennameController = TextEditingController();

  final TextEditingController parentcontactnoController =
      TextEditingController();

  final TextEditingController parentemailController = TextEditingController();

  String? fulldetail = '1';

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

  final _relationship = ['Mother', 'Father', 'Sibling', 'Grandparent'];
  String? _selectedRelationship = "";

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
                          TextFormField(
                            controller: contactnoController,
                            decoration:
                                InputDecoration(labelText: 'Contact No'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Contact No';
                              }
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
                          SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: MyMiddleText(text: "Parent information"),
                          ),
                          MyDivider(),
                          TextFormField(
                            controller: parennameController,
                            decoration:
                                InputDecoration(labelText: 'Parent Name'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your parent name';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Relationship",
                              prefixIcon: Icon(Icons.people_rounded),
                              border: UnderlineInputBorder(),
                            ),
                            value: _selectedRelationship,
                            items: _relationship
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedRelationship = val as String;
                              });
                            },
                          ),
                          TextFormField(
                            controller: parentcontactnoController,
                            decoration: InputDecoration(
                                labelText: 'Parent Contact Number'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your parent contact number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: parentemailController,
                            decoration:
                                InputDecoration(labelText: 'Parent Email'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Parent Email';
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
                                        confirmDialog();
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
            controller: postcodeController,
            decoration: InputDecoration(labelText: 'Postcode'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your postcode';
              }
              return null;
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
    } else if (_selectedNationality == _nationaltype[1]) {
      return Column(
        children: [
          TextFormField(
            controller: foreignCountryController,
            decoration: InputDecoration(labelText: 'Country'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your country';
              }
              return null;
            },
          ),
          TextFormField(
            controller: postcodeController,
            decoration: InputDecoration(labelText: 'Postcode'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your postcode';
              }
              return null;
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

  confirmDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "I already confirm all my detail insert correctly "),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(14),
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          //navigator
                          updatePersonalInfo(context);
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/auth', (route) => false);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

// havent done
  updatePersonalInfo(BuildContext context) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        "home_address": homeaddressController.text,
        "nationality": _selectedNationality as String,
        "postcode": postcodeController.text,
        "parent_name": parennameController.text,
        "relationship": _selectedRelationship as String,
        "parent_contact_no": parentcontactnoController.text,
        "parent_email": parentemailController.text,
        "full_detail": fulldetail
      });

      if (_selectedNationality == _nationaltype[0]) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "state": _selectedState as String,
        });
      } else if (_selectedNationality == _nationaltype[1]) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "country": foreignCountryController.text,
        });
      }
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
