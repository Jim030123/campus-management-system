import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

import '../../components/my_camera.dart';
import '../../documentation/term_and_condition.dart';

class RegistrationVehicleFormM extends StatefulWidget {
  String id;

  RegistrationVehicleFormM({super.key, required this.id});

  @override
  _RegistrationVehicleFormMState createState() =>
      _RegistrationVehicleFormMState();
}

class _RegistrationVehicleFormMState extends State<RegistrationVehicleFormM> {
  @override
  _RegistrationVehicleFormMState() {}

  final _formKey = GlobalKey<FormState>();

  final TextEditingController vehiclenumberController = TextEditingController();
  final TextEditingController modelnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  final String status = "Approved";

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

                          // ElevatedButton(
                          //   child: Text('Take Photo'),
                          //   onPressed: () async {
                          //     await availableCameras().then((value) =>
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (_) =>
                          //                     CameraPage(cameras: value))));
                          //   },
                          // ),

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
                                width: MediaQuery.of(context).size.width * 0.7,
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




class RegisterVisitorPassM extends StatefulWidget {
  String id;
  RegisterVisitorPassM({Key? key, required this.id}) : super(key: key);

  @override
  _RegisterVisitorPassMState createState() => _RegisterVisitorPassMState();
}

class _RegisterVisitorPassMState extends State<RegisterVisitorPassM> {
  _RegisterVisitorPassMState() {
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
  final String status = "Waiting the Management Review";

  final _vehicletype = ['Motorcycle', 'Car', 'Bus'];

  String? _selectedVehicleType = "";

  DateTime datevisit = DateTime.now();
  bool checkboxValue = false;
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Date Selected: ${datevisit.year}/${datevisit.month}/${datevisit.day}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: datevisit,
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );

                                    if (newDate == null) return;
                                    setState(() => datevisit = newDate);
                                  },
                                  child: Text('Select Visit Date'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Time Selected: ${_selectedTime.format(context)}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _selectTime(context);
                                  },
                                  child: Text('Select Visit Time'),
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
    DateTime timestamp = DateTime.now();

    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;
      String formattedDateVisit = DateFormat('yyyy/MM/dd').format(datevisit);
      String formattedTimeVisit = DateFormat.Hm().format(
        DateTime(datevisit.year, datevisit.month, datevisit.day,
            _selectedTime.hour, _selectedTime.minute),
      );
      String formattedTimeStamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc()
          .set({
        "name": nameController.text,
        "email": emailController.text,
        "nric": nricController.text,
        "vehicle_plate_number": vehicleplatenumberController.text,
        "vehicle_type": _selectedVehicleType as String,
        "date_visit": formattedDateVisit,
        "time_visit": formattedTimeVisit,
        "status": status,
        "reason": reasonController.text,
        "timestamp": formattedTimeStamp,
        "entry_time":null,
        "exit_time":null,

        "visitorid": auth
      });
      print(auth);
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
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

  void _confirmDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Submit the visitor Pass'),
          content:
              Text('This will send the visitor pass to management to review'),
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


class ResidentApplicationPageM extends StatefulWidget {
  String id;

  ResidentApplicationPageM({super.key, required this.id});

  @override
  _ResidentApplicationPageMState createState() =>
      _ResidentApplicationPageMState();
}

class _ResidentApplicationPageMState extends State<ResidentApplicationPageM> {
  _ResidentApplicationPageMState() {
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
  final String status = "Wait the Management Review";
  final String roomno = "";
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
      final user = widget.id;

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
                                          color: const Color.fromARGB(
                                              255, 33, 40, 243),
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
        "student_id": studentidController.text,
        "parent_name": parentnameController.text,
        "relationship": relationshipController.text,
        "parent_contact_no": parentcontactnoController.text,
        "parent_email": parentemailController.text,
        "room_type": _selectedRoomType as String,
        "status": status,
        "room_no": roomno,
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
          title: Text('Submit your student resident form'),
          content: Text(
            'This will also sent the student resident form to management',
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

