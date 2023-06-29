import 'package:campus_management_system/components/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';

class AddRoomForm extends StatefulWidget {
  AddRoomForm({super.key});

  @override
  _AddRoomFormState createState() => _AddRoomFormState();
}

class _AddRoomFormState extends State<AddRoomForm> {
  _AddRoomFormState() {
    _selectedroomType = _roomtype[0];
    _selectedroomgender = _roomgender[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController roomnoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController describeFeedbackController =
      TextEditingController();
  final TextEditingController supportingEvidenceController =
      TextEditingController();
  final TextEditingController relationController = TextEditingController();

  final _roomtype = [
    'Twin Sharing (Air Conditioned) (Block A & C)',
    'Twin Sharing (Non Air Conditioned) (Block B & D)',
    'Twin Sharing (Air Conditioned) (Block E)',
    'Trio Sharing (Air Conditioned) (Block E)'
  ];

  final _roomgender = ['Male', 'Female'];

  String? _selectedroomType = "";
  String? _selectedroomgender = "";

  bool checkboxValue = false;

  late int maxCapacity;
  late List name;
  late List id;
  late int currentperson = 0;
  late List<String> currentPersonName;

  @override
  Widget build(BuildContext context) {
    if (_selectedroomType == _roomtype[0] ||
        _selectedroomType == _roomtype[1] ||
        _selectedroomType == _roomtype[2]) {
      maxCapacity = 2;
      currentPersonName = List<String>.filled(2, "empty");
    } else {
      maxCapacity = 3;
      currentPersonName = List<String>.filled(3, "empty");
    }
    return Scaffold(
        appBar: MyAppBar(),
        drawer: MyStudentDrawer(),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Add Room',
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
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Room Gender",
                          prefixIcon: Icon(Icons.people_alt_rounded),
                          border: UnderlineInputBorder(),
                        ),
                        value: _selectedroomgender,
                        items: _roomgender
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedroomgender = val as String;
                          });
                        },
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: "Room Type",
                          prefixIcon: Icon(Icons.room_preferences_rounded),
                          border: UnderlineInputBorder(),
                        ),
                        value: _selectedroomType,
                        items: _roomtype
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedroomType = val as String;
                          });
                        },
                        isExpanded: true,
                      ),
                      TextFormField(
                        controller: roomnoController,
                        decoration: InputDecoration(labelText: 'Room No'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Room No';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              room(context);
                            }
                          },
                          child: Text('Add Room'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }

  room(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('room_available')
          .doc(roomnoController.text)
          .set({
        "room_no": roomnoController.text,
        "room_gender": _selectedroomgender as String,
        "room_type": _selectedroomType as String,
        "max_capacity": maxCapacity,
        "current_person": currentperson,
        "student_name_id": currentPersonName
      });
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }
}
