import 'dart:io';
import 'package:camera/camera.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/my_camera.dart';
import '../../documentation/term_and_condition.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegistrationVehicleForm extends StatefulWidget {
  RegistrationVehicleForm({super.key});

  @override
  _RegistrationVehicleFormState createState() =>
      _RegistrationVehicleFormState();
}

class _RegistrationVehicleFormState extends State<RegistrationVehicleForm> {
  _RegistrationVehicleFormState() {
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
          "user_id": idController.text,
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
          title: Text('Register Vehicle Pass'),
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
