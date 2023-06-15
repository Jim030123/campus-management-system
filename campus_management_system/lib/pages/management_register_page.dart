import 'package:campus_management_system/components/my_alert_dialog.dart';
import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/role.dart';
import 'package:intl/intl.dart';
import 'package:campus_management_system/pages/general/login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  _RegistrationPageState() {
    _selectedRole = _roles[0];
    _selectedProgram = _program[0];
  }
  // bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController icorpassportController = TextEditingController();
  final TextEditingController contactnoController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final _roles = ['Resident_Student', 'Management', 'Visitor'];
  final List<String> _program = [
    'FAD-Diploma in Advertising Design',
    'FAD-Diploma in Industrial Design',
    'FAD-Bachelor of Design (Honours) Computer Graphic Design',
    'FAD-Bachelor In Industrial Design (Honours)',
    'FBM-Diploma in Accountancy',
    'FBM-Bachelor of Business Administration (Honours) in Finance & Investment',
    'FBM-Bachelor in Accounting (Honours)',
    'FBM-Diploma in Marketing',
    'FBM-Diploma in Logistics Management',
    'FBM-Bachelor of Business Administration (Honours) in Marketing',
    'FBM-Bachelor of Business Administration (Honours) in Tourism Management',
    'FBM-Diploma in Business Administration',
    'FBM-Bachelor of Business Administration (Honours)',
    'FBM-Bachelor of Business Administration (Honours) in Human Resource Management',
    'FBM-Bachelor of Property Management (Honours)',
    'FBM-Master of Business Administration',
    'FBM-Doctor of Philosophy (Business Administration)',
    'FBM-Doctor of Business Administration',
    'FCS-Diploma in Chinese Studies',
    'FCS-Bachelor of Arts (Honours) Chinese Studies',
    'FCS-Master of Arts in Chinese Studies',
    'FCS-Doctor of Philosophy (Chinese Studies)',
    'FEIT-Diploma in Information Technology',
    'FEIT-Bachelor of Software Engineering (Honours)',
    'FEIT-Master of Science (Computer Science)',
    'FEIT-Diploma in Electrical & Electronic Engineering',
    'FEIT-Bachelor of Electronic Engineering with Honours',
    'FHSS-Department of Languages & General Studies',
    'FHSS-Bachelor of Arts (Honours) English Language Teaching',
    'FHSS-Bachelor of Communication (Honours) (Mass Communication)',
    'FHSS-Master of Communication',
    'FHSS-Bachelor of Education (Honours) (Guidance & Counselling)',
    'FHSS-Bachelor of Psychology (Honours)',
    'FHSS-Diploma in Early Childhood Education',
    'FHSS-Bachelor of Early Childhood Education (Honours)',
    'Foundation Studies-Foundation in Arts',
    'Foundation Studies-Foundation in Science',
    'Visitor'
  ];

  DateTime dob = DateTime.now();

  String? _selectedRole = "";
  String? _selectedProgram = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Register New Account',
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
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      // IC / Passport No.

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date of Birth :${dob.year}/${dob.month}/${dob.day}',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: dob,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                if (newDate == null) return;
                                setState(() => dob = newDate);
                              },
                              child: Text('select date of birth')),
                        ],
                      ),

                      TextFormField(
                        controller: contactnoController,
                        decoration: InputDecoration(labelText: 'Contact No'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter the Contact Number';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Please enter a password at least 6 letter or number!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: idController,
                        decoration: InputDecoration(
                            labelText:
                                'Student ID / Management ID (Ignore this field if you doesn\'t have any ID  )'),
                      ),

                      SizedBox(height: 16.0),

                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: "Role",
                            prefixIcon: Icon(Icons.verified_user),
                            border: UnderlineInputBorder()),
                        value: _selectedRole,
                        items: _roles
                            .map((e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedRole = val as String;
                          });
                        },
                      ),

                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: "Program",
                            prefixIcon: Icon(Icons.book),
                            border: UnderlineInputBorder()),
                        value: _selectedProgram,
                        items: _program
                            .map((f) => DropdownMenuItem(
                                  child: Text(f),
                                  value: f,
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedProgram = val as String;
                          });
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _checkTextLength();

                            if (_formKey.currentState!.validate()) {
                              signUpWithEmail(context);
                              _confirmDialog();

                              // createUserDocument();
                            }
                          },
                          child: Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpWithEmail(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;
      String formattedDob = DateFormat('yyyy/MM/dd').format(dob);

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        "name": nameController.text,
        "dob": formattedDob,
        "contact_no": contactnoController.text,
        "email": emailController.text,
        "roles": _selectedRole as String,
        "program": _selectedProgram as String,
        "id": idController.text,
        "room_type": null
      });

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
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

  void _checkTextLength() {
    if (passwordController.text.length < 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Authentication Error'),
            content: Text('Text length must be at least 6 characters.'),
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
}
