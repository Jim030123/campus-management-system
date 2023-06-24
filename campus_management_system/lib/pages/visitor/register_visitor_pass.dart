import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/role.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

import '../../documentation/term_and_condition.dart';

class RegisterVisitorPass extends StatefulWidget {
  final String id;
  RegisterVisitorPass({super.key, required this.id});

  @override
  _RegisterVisitorPassState createState() => _RegisterVisitorPassState();
}

class _RegisterVisitorPassState extends State<RegisterVisitorPass> {
  _RegisterVisitorPassState() {
    _selectedVehicleType = _vehicletype[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nricController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController vehicleplatenumberController =
      TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final String status = "Wait the Management Review";

  final _vehicletype = ['Motorcycle', 'Car', 'Bus'];

  String? _selectedVehicleType = "";

  DateTime datevisit = DateTime.now();
  bool checkboxValue = false;
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getdatafromDB() async {
      // final user = widget.id;
      final user = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Replace with your collection name
          .doc(user) // Use the provided document ID
          .get();

      String name = await snapshot.get('name');
      String email = await snapshot.get('email');
      // String id = await snapshot.get('id');
      return [name, email];
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

            nameController.text = name;
            emailController.text = email;

            return Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Visitor Pass Application',
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
                            controller: nricController,
                            decoration: InputDecoration(labelText: 'NRIC'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date Visit: ${datevisit.year}/${datevisit.month}/${datevisit.day}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      DateTime? newDate = await showDatePicker(
                                          context: context,
                                          initialDate: datevisit,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(2100));

                                      if (newDate == null) return;
                                      setState(() => datevisit = newDate);
                                    },
                                    child: Text('Select Visit Date')),
                                SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _selectTime(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Icon(Icons.access_time),
                                        Text('  Time:  '),
                                        Text(
                                          _selectedTime != null
                                              ? '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')}'
                                              : 'Select time',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: reasonController,
                            decoration:
                                InputDecoration(labelText: 'Reason to visit'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Reason to visit';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: "Vehicle Type",
                              prefixIcon: Icon(Icons.verified_user),
                              border: UnderlineInputBorder(),
                            ),
                            value: _selectedVehicleType,
                            items: _vehicletype
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedVehicleType = val as String;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          TextFormField(
                            controller: vehicleplatenumberController,
                            decoration: InputDecoration(
                              labelText: 'Vehicle plate Number',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Vehicle number';
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
                                    Text(
                                      "I have read and agree to Terms of Service and Privacy Policy",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 33, 40, 243),
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
                                        VisitorPassApplication(context);
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

  VisitorPassApplication(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;
      String formattedDateVisit = DateFormat('yyyy/MM/dd').format(datevisit);
      String formattedTimeVisit = DateFormat.jm() as String;
      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(auth)
          .set({
        "name": nameController.text,
        "email": emailController.text,
        "NRIC": nricController.text,
        "vehicle_plate_number": vehicleplatenumberController.text,
        "vehicle_type": _selectedVehicleType as String,
        "date_visit": formattedDateVisit,
        // "time_visit": formattedTimeVisit,
        "status": status,
        "reason": reasonController.text
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
          title: Text('Create Visitor Pass'),
          content: Text(
            'Please waiting management approve this Visitor Pass, the Management will review this visitor pass within 24 hour.',
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

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service and Privacy Policy'),
          content: VisitorPassTnC(),
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
