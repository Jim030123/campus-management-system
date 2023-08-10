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
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import '../../components/my_camera.dart';
import '../../components/my_divider.dart';
import '../../components/my_textstyle.dart';
import '../../documentation/term_and_condition.dart';

class RegistrationVehicleFormM extends StatefulWidget {
  String id;

  RegistrationVehicleFormM({super.key, required this.id});

  @override
  _RegistrationVehicleFormMState createState() =>
      _RegistrationVehicleFormMState();
}

class _RegistrationVehicleFormMState extends State<RegistrationVehicleFormM> {
  _RegistrationVehicleFormMState() {
    _selectedVehicleBrand = _vehicleBrand[0];
    _selectedVehicleType = _vehicleType[0];
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController vehiclenumberController = TextEditingController();
  final TextEditingController modelnameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController idController = TextEditingController();
  final String status = "Waiting the Management Review";

  bool checkboxValue = false;

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

  final _vehicleType = ['Motorcycle', 'Car', 'Bus'];

  String? _selectedVehicleBrand = "";

  String? _selectedVehicleType = "";

  XFile? takenPhoto; // Add a variable to store the taken photo

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

    // Function to handle the photo taken by the camera
    void _handlePhotoTaken(XFile photo) {
      setState(() {
        takenPhoto = photo;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Vehicle Form'),
      ),
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
                        'Register New Vehicle',
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
                              controller: idController,
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
                                labelText: "Vehicle Type",
                                prefixIcon: Icon(Icons.agriculture),
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
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: "Vehicle Brand",
                                prefixIcon: Icon(Icons.place),
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
                              controller: modelnameController,
                              decoration: InputDecoration(
                                  labelText: 'Vehicle Model Name'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Vehicle Model Name';
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
                                  return 'Please enter your Vehicle Plate Number';
                                }
                                if (value.contains(' ')) {
                                  return 'Vehicle number cannot contain spaces';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            MyDivider(),
                            Align(
                                alignment: Alignment.center,
                                child: MyMiddleText(
                                    text: "Please Take Vehicle Photo")),
                            MyDivider(),
                            SizedBox(height: 16.0),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                              'I agree all Term & Condition',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 35, 109, 193))))
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
            }
          },
        ),
      ),
    );
  }

  Future<void> registerVehicle(BuildContext context) async {
    try {
      String auth = FirebaseAuth.instance.currentUser!.uid;

      final vehicleRef = FirebaseFirestore.instance
          .collection('vehicle')
          .doc(vehiclenumberController.text.toUpperCase());

      // Upload the photo to Firebase Storage
      if (takenPhoto != null) {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('vehicle_photos/${vehicleRef.id}.jpg');

        await ref.putFile(File(takenPhoto!.path));

        final downloadUrl = await ref.getDownloadURL();

        await vehicleRef.set({
          "name": nameController.text,
          "email": emailController.text,
          "user_id": idController.text,
          "vehicle_number": vehiclenumberController.text.toUpperCase(),
          "vehicle_type": _selectedVehicleType as String,
          "vehicle_brand": _selectedVehicleBrand as String,
          "vehicle_model": modelnameController.text,
          "status": status,
          "photoUrl": downloadUrl,
          "id": auth // Save the photo URL in the database
        });
      } else {
        await vehicleRef.set({
          "name": nameController.text,
          "email": emailController.text,
          "id": idController.text,
          "vehicle_type": _selectedVehicleType as String,
          "vehicle_number": vehiclenumberController.text.toUpperCase(),
          "vehicle_brand": _selectedVehicleBrand as String,
          "vehicle_model": modelnameController.text,
          "status": status,
        });
      }
      print(auth);
    } on FirebaseAuthException catch (e) {
      // Handle the exception
    }
    // pop the loading circle
  }

  void _confirmDialog() async {
    // show loading circle

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Register Vehicle'),
          content: Text('The registration will send to management review'),
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

    // pop the loading circle
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms of Service and Privacy Policy'),
          content: SingleChildScrollView(child: RegisterVehicleTnC()),
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

class RegisterVisitorPassM extends StatefulWidget {
  String id;
  RegisterVisitorPassM({Key? key, required this.id}) : super(key: key);

  @override
  _RegisterVisitorPassMState createState() => _RegisterVisitorPassMState();
}

class _RegisterVisitorPassMState extends State<RegisterVisitorPassM> {
  _RegisterVisitorPassMState() {
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
                                if (value.contains(' ')) {
                                  return 'Vehicle number cannot contain spaces';
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
    } on FirebaseAuthException catch (e) {}
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
