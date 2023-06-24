import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:campus_management_system/pages/visitor/visitor_register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // getdatafromDB();
  }

  getdatafromDB() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(user) // Use the provided document ID
        .get();

    // Access the "role" field and convert it to a string
    String role = await snapshot.get('roles').toString();
    String gender = await snapshot.get('gender').toString();
    String name = await snapshot.get('name').toString();
    String dob = await snapshot.get('dob').toString();
    String nric = await snapshot.get('nric').toString();
    String email = await snapshot.get('email').toString();
    String id = await snapshot.get('id').toString();

    return [name, gender, dob, nric, email, role, id];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyStudentDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getdatafromDB(),
          builder: (context, snapshot) {
            // String name = snapshot.data as String;

            List<String> basicProfileDetail = snapshot.data as List<String>;
            String name = basicProfileDetail[0];
            String gender = basicProfileDetail[1];
            String dob = basicProfileDetail[2];
            String nric = basicProfileDetail[3];
            String email = basicProfileDetail[4];

            String role = basicProfileDetail[5];
            String id = basicProfileDetail[6];

            return Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Personal Profile",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        QrImageView(
                          backgroundColor: Colors.white,
                          data: user,
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("user ID: " + user),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.7, // Set a maximum width for the program text
                                ),
                                // color: Colors.blue,
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: MyMiddleText(
                                          text: 'Basic information',
                                        )),
                                    MyDivider(),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Name: ' +
                                            name +
                                            '\nDate of Birth: ' +
                                            dob +
                                            "\nGender: " +
                                            gender +
                                            "\nEmail: " +
                                            email +
                                            "\nRole: " +
                                            role,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    FutureBuilder(
                                      future: fulldetail(role),
                                      builder: (context, snapshot) {
                                        List<String> roledetail =
                                            snapshot.data as List<String>;

                                        return roleinfo(role, roledetail);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

fulldetail(String role) async {
  final user = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users') // Replace with your collection name
      .doc(user) // Use the provided document ID
      .get();

  String address = await snapshot.get('address').toString();
  

  return [address];
}

roleinfo(String role, List roledetail) {
  String address = roledetail[0];
  if (role == "Student") {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: MyMiddleText(
              text: role + ' information',
            )),
        MyDivider(),
        Align(child: Text('Address:' + address))
      ],
    );
  } else {
    return Container();
  }
}
