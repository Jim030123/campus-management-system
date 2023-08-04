import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:campus_management_system/pages/Account/Student/student_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../function/database.dart';

class StudentProfilePage extends StatefulWidget {
  StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
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

    if (role == "Student") {
      String gender = await snapshot.get('gender').toString();
      String name = await snapshot.get('name').toString();
      String dob = await snapshot.get('dob').toString();
      String contactno = await snapshot.get('contact_no').toString();
      String nric = await snapshot.get('nric').toString();
      String email = await snapshot.get('email').toString();
      String id = await snapshot.get('id').toString();
      String fulldetail = await snapshot.get('full_detail').toString();

      return [name, gender, dob, nric, email, contactno, role, id, fulldetail];
    }
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Center(
                      child:
                          CircularProgressIndicator())); // Display circular progress indicator while data is loading
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'), // Display error message
              );
            } else {
              List<String> studentdetail = snapshot.data as List<String>;
              String name = studentdetail[0];
              String gender = studentdetail[1];
              String dob = studentdetail[2];
              String nric = studentdetail[3];
              String email = studentdetail[4];
              String contactno = studentdetail[5];

              String role = studentdetail[6];
              String id = studentdetail[7];
              String full_detail = studentdetail[8];

              return SingleChildScrollView(
                child: Container(
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
                                      maxWidth: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.8, // Set a maximum width for the program text
                                    ),
                                    // color: Colors.blue,
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                                "\nGender: " +
                                                gender +
                                                '\nDate of Birth: ' +
                                                dob +
                                                "\nNRIC: " +
                                                nric +
                                                "\nEmail: " +
                                                email +
                                                "\nContact No: " +
                                                contactno +
                                                "\nRole: " +
                                                role +
                                                "\nID: " +
                                                id,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        FutureBuilder(
                                          future: fulldetail(role),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(); // or any loading indicator
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    'Error occurred while loading data'),
                                              );
                                            } else {
                                              List<String> roledetail =
                                                  snapshot.data as List<String>;
                                              return roleinfo(role, roledetail);
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
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
                ),
              );
            }
          },
        ),
      ),
    );
  }

// get data

  fulldetail(String role) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(user) // Use the provided document ID
        .get();

    String homeaddress = snapshot.get('home_address').toString();
    String postcode = snapshot.get('postcode').toString();
    String nationality = snapshot.get('nationality').toString();

    String parentname = snapshot.get('parent_name');
    String relationship = snapshot.get('relationship');
    String parentemail = snapshot.get('parent_email');
    String parentcontactno = snapshot.get('parent_contact_no');

    if (nationality == "National Resident") {
      String state = snapshot.get('state').toString();

      return [
        nationality,
        state,
        postcode,
        homeaddress,
        parentname,
        relationship,
        parentemail,
        parentcontactno
      ];
    } else if (nationality == "Foreign Resident") {
      String country = snapshot.get('country').toString();
      return [
        nationality,
        country,
        postcode,
        homeaddress,
        parentname,
        relationship,
        parentemail,
        parentcontactno
      ];
    }
  }

  roleinfo(String role, List roledetail) {
    String nationality = roledetail[0];

    if (role == "Student" && nationality == "National Resident") {
      String stateOrcountry = roledetail[1];
      String postcode = roledetail[2];
      String homeaddress = roledetail[3];
      String parentname = roledetail[4];
      String relationship = roledetail[5];
      String parentemail = roledetail[6];
      String parentcontactno = roledetail[7];

      return Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: MyMiddleText(
                text: role + ' information',
              )),
          MyDivider(),
          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text('Nationality : ' +
                      nationality +
                      '\nState : ' +
                      stateOrcountry +
                      '\nPostcode : ' +
                      postcode +
                      '\nHome Address: ' +
                      homeaddress +
                      '\nParent Name : ' +
                      parentname +
                      '\nRelationship : ' +
                      relationship +
                      '\nParent Email : ' +
                      parentemail +
                      '\nParent Contact No: ' +
                      parentcontactno)
                ],
              ))
        ],
      );
    } else {
      return Container();
    }
  }
}

class VistitorProfilePage extends StatelessWidget {
  VistitorProfilePage({super.key});

  String userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: FutureBuilder(
          future: findUserById(userid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // or any loading indicator
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error occurred while loading data'),
              );
            } else {
              DocumentSnapshot visitorData = snapshot.data!;

              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: MyLargeText(text: "Visitor Personal Detail")),
                    MyDivider(),
                    Container(
                      padding: EdgeInsets.all(25),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey),
                      child: Column(children: [
                        QrImageView(
                          backgroundColor: Colors.white,
                          data: userid,
                          version: QrVersions.auto,
                          size: 150.0,
                        ),
                        Text("UserID :" + userid),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: MySmallText(
                              text: "Name: " +
                                  visitorData["name"] +
                                  "\nNRIC: " +
                                  visitorData["nric"] +
                                  "\nGender: " +
                                  visitorData["gender"] +
                                  "\nEmail: " +
                                  visitorData["email"] +
                                  "\nContact No: " +
                                  visitorData["contact_no"] +
                                  "\nHome Address: " +
                                  visitorData["home_address"] +
                                  "\nState: " +
                                  visitorData["state"] +
                                  "\nPostcode: " +
                                  visitorData["postcode"]),
                        )
                      ]),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class ManagementProfilePage extends StatefulWidget {
  ManagementProfilePage({super.key});

  @override
  State<ManagementProfilePage> createState() => _ManagementProfilePage();
}

class _ManagementProfilePage extends State<ManagementProfilePage> {
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
    String contactno = await snapshot.get('contact_no').toString();
    String nric = await snapshot.get('nric').toString();
    String email = await snapshot.get('email').toString();
    String id = await snapshot.get('id').toString();
    String fulldetail = await snapshot.get('full_detail').toString();
    String position = await snapshot.get('position').toString();
    return [
      name,
      gender,
      dob,
      nric,
      email,
      contactno,
      role,
      position,
      id,
      fulldetail
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyManagementDrawer(),
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
              List<String> studentdetail = snapshot.data as List<String>;
              String name = studentdetail[0];
              String gender = studentdetail[1];
              String dob = studentdetail[2];
              String nric = studentdetail[3];
              String email = studentdetail[4];
              String contactno = studentdetail[5];

              String role = studentdetail[6];
              String position = studentdetail[7];
              String id = studentdetail[8];
              String full_detail = studentdetail[9];

              return SingleChildScrollView(
                child: Container(
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
                                      maxWidth: MediaQuery.of(context)
                                              .size
                                              .width *
                                          0.8, // Set a maximum width for the program text
                                    ),
                                    // color: Colors.blue,
                                    alignment: Alignment.topLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                                "\nGender: " +
                                                gender +
                                                '\nDate of Birth: ' +
                                                dob +
                                                "\nNRIC: " +
                                                nric +
                                                "\nEmail: " +
                                                email +
                                                "\nContact No: " +
                                                contactno +
                                                "\nRole: " +
                                                role +
                                                "\nPosition: " +
                                                position +
                                                "\nID: " +
                                                id,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        FutureBuilder(
                                          future: fulldetail(role),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(); // or any loading indicator
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    'Error occurred while loading data'),
                                              );
                                            } else {}
                                            List<String> roledetail =
                                                snapshot.data as List<String>;

                                            return roleinfo(role, roledetail);
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
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
                ),
              );
            }
          },
        ),
      ),
    );
  }

// get data

  fulldetail(String role) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(user) // Use the provided document ID
        .get();

    String homeaddress = snapshot.get('home_address').toString();
    String postcode = snapshot.get('postcode').toString();
    String nationality = snapshot.get('nationality').toString();

    String parentname = snapshot.get('parent_name');
    String relationship = snapshot.get('relationship');
    String parentemail = snapshot.get('parent_email');
    String parentcontactno = snapshot.get('parent_contact_no');

    if (nationality == "National Resident") {
      String state = snapshot.get('state').toString();

      return [
        nationality,
        state,
        postcode,
        homeaddress,
        parentname,
        relationship,
        parentemail,
        parentcontactno
      ];
    } else if (nationality == "Foreign Resident") {
      String country = snapshot.get('country').toString();
      return [
        nationality,
        country,
        postcode,
        homeaddress,
        parentname,
        relationship,
        parentemail,
        parentcontactno
      ];
    }
  }

  roleinfo(String role, List roledetail) {
    String nationality = roledetail[0];

    if (role == "Management") {
      String stateOrcountry = roledetail[1];
      String postcode = roledetail[2];
      String homeaddress = roledetail[3];
      String parentname = roledetail[4];
      String relationship = roledetail[5];
      String parentemail = roledetail[6];
      String parentcontactno = roledetail[7];

      return Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: MyMiddleText(
                text: role + ' information',
              )),
          MyDivider(),
          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text('Nationality : ' +
                      nationality +
                      '\nState : ' +
                      stateOrcountry +
                      '\nPostcode : ' +
                      postcode +
                      '\nHome Address: ' +
                      homeaddress +
                      '\nParent Name : ' +
                      parentname +
                      '\nRelationship : ' +
                      relationship +
                      '\nParent Email : ' +
                      parentemail +
                      '\nParent Contact No: ' +
                      parentcontactno)
                ],
              ))
        ],
      );
    } else {
      return Container();
    }
  }
}
