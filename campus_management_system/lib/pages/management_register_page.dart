import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:campus_management_system/role.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  _RegistrationPageState() {
    _selectedRole = _roles[0];
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final _roles = ['Hostel_Student', 'Management', 'Visitor'];
  String? _selectedRole = "";

  FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> data = {
                    "email": emailController.text,
                    "roles": _selectedRole as String
                  };

                  FirebaseFirestore.instance.collection("user").add(data);

                  final snackBar = SnackBar(
                    content: Text('You have created a ' +
                        _selectedRole! +
                        ' for this account: ' +
                        emailController.text),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  signUserUp;
                },
                child: Text('Register'),
              ),
              Text(user.uid)
            ],
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore(String email, String rool) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'email': emailController.text, 'role': _roles});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => RegistrationPage()));
  }

  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      // check if password is confirmed

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {}

    // pop the loading circle
  }
}
