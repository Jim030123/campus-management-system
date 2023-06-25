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
                                      ),

                                      residentstudentdetail()
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
          },
        ),
      ),
    );
  }
}
residentstudentdetail()async{
    final user = FirebaseAuth.instance.currentUser!.uid;
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users') // Replace with your collection name
      .doc(user) // Use the provided document ID
      .get();

       String homeaddress = snapshot.get('home_address').toString();


}

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
  } else if (nationality == "country") {
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

  if (role == "Student") {
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
