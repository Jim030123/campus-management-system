import 'dart:io';

import 'package:camera/camera.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../components/my_camera.dart';
import '../../documentation/term_and_condition.dart';
import '../../components/my_alert_dialog.dart';
import '../../components/my_appbar.dart';
import '../../components/my_drawer.dart';
import '../general/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterVisitorPass extends StatefulWidget {
  RegisterVisitorPass({Key? key}) : super(key: key);

  @override
  _RegisterVisitorPassState createState() => _RegisterVisitorPassState();
}

class _RegisterVisitorPassState extends State<RegisterVisitorPass> {
  _RegisterVisitorPassState() {
    _selectedVehicleType = _vehicleType[0];
    _selectedVisitorPassType = _visitorPassType[0];
    _selectedVehicleBrand = _vehicleBrand[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nricController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();

  final TextEditingController vehiclemodelController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  final String status = "Waiting the Management Review";

  final _visitorPassType = ['Short Term', 'Long Term'];

  final _vehicleBrand = [
    'Perodua',
    'Proton',
    'Honda',
    'Toyota',
    'BMW',
    'Audi',
    'Lexus',
    'Mazda',
    'Mercedes-Benz',
    'Nissan',
    'Suzuki',
    'Volvo',
    'Ford',
    'Subaru',
    'Porsche',
    'Mitsubishi',
    'Infiniti',
    'Hyundai',
    'Chevrolet',
    'Isuzu'
  ];

  String? _selectedVisitorPassType = "";
  String? _selectedVehicleBrand = "";

  final _vehicleType = ['Motorcycle', 'Car', 'Bus'];

  String? _selectedVehicleType = "";

  DateTime datevisit = DateTime.now();
  DateTime enddatevisit = DateTime.now();
  bool checkboxValue = false;
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _handlePhotoTaken(XFile photo) {
    setState(() {
      takenPhoto = photo;
    });
  }

  XFile? takenPhoto;

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

  getdatafromDB() async {
    // final user = widget.id;
    final user = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(user) // Use the provided document ID
        .get();

    String name = await snapshot.get('name');
    String email = await snapshot.get('email');
    String nric = await snapshot.get('nric');
    return [name, email, nric];
  }

  initState() {
    super.initState();
    getdatafromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or any loading indicator
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred while loading data'),
              );
            } else {
              List<String> dataList = snapshot.data as List<String>;
              String name = dataList[0];
              String email = dataList[1];
              String nric = dataList[2];

              nameController.text = name;
              emailController.text = email;
              nricController.text = nric;

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
                              controller: nricController,
                              decoration: InputDecoration(labelText: 'NRIC'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your NRIC';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: "Visitor Pass Type",
                                prefixIcon: Icon(Icons.badge_rounded),
                                border: UnderlineInputBorder(),
                              ),
                              value: _selectedVisitorPassType,
                              items: _visitorPassType
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedVisitorPassType = val as String;
                                });
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            MyMiddleText(text: "Visit Period"),
                            MyDivider(),
                            visitorType(),
                            MyDivider(),
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
                              items: _vehicleType
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
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: "Vehicle Brand",
                                prefixIcon: Icon(Icons.car_crash),
                                border: UnderlineInputBorder(),
                              ),
                              value: _selectedVehicleBrand,
                              items: _vehicleBrand
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedVehicleBrand = val as String;
                                });
                              },
                            ),
                            TextFormField(
                              controller: vehiclemodelController,
                              decoration: InputDecoration(
                                labelText: 'Vehicle Model',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Vehicle Model';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: vehicleNumberController,
                              decoration: InputDecoration(
                                labelText: 'Vehicle Plate Number',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Vehicle number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            if (takenPhoto != null) // Display the taken photo
                              Center(
                                child: Container(
                                    width: 300,
                                    child: Image.file(File(takenPhoto!.path))),
                              ),
                            ElevatedButton(
                              child: Text('Take Photo'),
                              onPressed: () async {
                                await availableCameras().then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CameraPage(
                                        cameras: value,
                                        onPhotoTaken:
                                            _handlePhotoTaken, // Pass the callback function
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                            SizedBox(height: 16.0),
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
            }
          },
        ),
      ),
    );
  }

  VisitorPassApplication(BuildContext context) async {
    DateTime registerTime = DateTime.now();

    String auth = FirebaseAuth.instance.currentUser!.uid;
    String formattedDateVisit = DateFormat('yyyy/MM/dd').format(datevisit);

    String formattedEndDateVisit =
        DateFormat('yyyy/MM/dd').format(enddatevisit);

    DateTime ExpiredDateTime =
        DateTime(datevisit.year, datevisit.month, datevisit.day, 23, 59, 59);
    Timestamp shortTermPassExpired = Timestamp.fromDate(ExpiredDateTime);

    DateTime ExpiredDatevisitTime = DateTime(
        enddatevisit.year, enddatevisit.month, enddatevisit.day, 23, 59, 59);
    Timestamp longTermPassExpired = Timestamp.fromDate(ExpiredDatevisitTime);

    String formattedTimeVisit = DateFormat.Hm().format(
      DateTime(datevisit.year, datevisit.month, datevisit.day,
          _selectedTime.hour, _selectedTime.minute),
    );
    String formattedTimeStamp =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(registerTime);

    String visitorPassID = Uuid().v4();
    try {
      if (_selectedVisitorPassType == _visitorPassType[0]) {
        await FirebaseFirestore.instance
            .collection('visitor_pass_application')
            .doc(visitorPassID)
            .set({
          "name": nameController.text,
          "email": emailController.text,
          "nric": nricController.text,

          "date_visit": formattedDateVisit,
          "status": status,
          "reason": reasonController.text,

          // register time
          "timestamp": formattedTimeStamp,
          "expired_timestamp": shortTermPassExpired,

          "entry_time": "",
          "exit_time": "",
          "visitorid": auth,
          "time_visit": formattedTimeVisit,
          "visitor_pass_type": _selectedVisitorPassType as String,

          "visitor_pass_id": visitorPassID,
          "vehicle_number": vehicleNumberController.text.toUpperCase(),
          "vehicle_model": vehiclemodelController.text,
          "vehicle_brand": _selectedVehicleBrand as String,
          "vehicle_type": _selectedVehicleType as String
        });
      } else if (_selectedVisitorPassType == _visitorPassType[1]) {
        await FirebaseFirestore.instance
            .collection('visitor_pass_application')
            .doc(visitorPassID)
            .set({
          "name": nameController.text,
          "email": emailController.text,
          "nric": nricController.text,
          "start_date_visit": formattedDateVisit,
          "status": status,
          "reason": reasonController.text,
          "timestamp": formattedTimeStamp,
          "visitorid": auth,
          "end_date_visit": formattedEndDateVisit,
          "visitor_pass_type": _selectedVisitorPassType as String,
          "expired_timestamp": longTermPassExpired,
          "visitor_pass_id": visitorPassID,
          "vehicle_number": vehicleNumberController.text.toUpperCase(),
          "vehicle_model": vehiclemodelController.text,
          "vehicle_brand": _selectedVehicleBrand as String,
          "vehicle_type": _selectedVehicleType as String
        });
      }

      try {
        final vehicleRef =
            FirebaseFirestore.instance.collection('vehicle').doc(visitorPassID);
        if (takenPhoto != null) {
          final ref = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('vehicle_photos/${vehicleRef.id}.jpg');

          await ref.putFile(File(takenPhoto!.path));

          final downloadUrl = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('vehicle')
              .doc(vehicleNumberController.text)
              .set({
            "name": nameController.text,
            "vehicle_number": vehicleNumberController.text.toUpperCase(),
            "vehicle_model": vehiclemodelController.text,
            "vehicle_brand": _selectedVehicleBrand as String,
            "vehicle_type": _selectedVehicleType as String,
            "status": status,
            "id": auth,
            "photoUrl": downloadUrl,
          });
        }
      } catch (e) {}
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
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
          ),
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  visitorType() {
    if (_selectedVisitorPassType == _visitorPassType[0]) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
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
            Column(
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
          ],
        ),
      );
    } else if (_selectedVisitorPassType == _visitorPassType[1]) {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Start Date: ${datevisit.year}/${datevisit.month}/${datevisit.day}',
                    style: TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? StartDate = await showDatePicker(
                        context: context,
                        initialDate: datevisit,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (StartDate == null) return;
                      setState(() => datevisit = StartDate);
                    },
                    child: Text('Select Visit Start Date'),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Date End: ${enddatevisit.year}/${enddatevisit.month}/${enddatevisit.day}',
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? endDate = await showDatePicker(
                      context: context,
                      initialDate: enddatevisit,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    if (endDate == null) return;
                    setState(() => enddatevisit = endDate);
                  },
                  child: Text('Select Visit End Date'),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
