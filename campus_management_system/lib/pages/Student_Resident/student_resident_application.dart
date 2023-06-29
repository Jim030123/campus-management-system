import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:campus_management_system/pages/student_resident/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentResidentApplicationPage extends StatefulWidget {
  const StudentResidentApplicationPage({Key? key}) : super(key: key);

  @override
  _StudentResidentApplicationPageState createState() =>
      _StudentResidentApplicationPageState();
}

class _StudentResidentApplicationPageState
    extends State<StudentResidentApplicationPage> {
  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;
  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('resident_application');

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allApplication = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void _openNewPage(DocumentSnapshot user) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ApplicationDetail(user: user),
    //   ),
    // );
  }

  List<String> status = [
    'Waiting the Management Review',
    'Approved',
    'Declined'
  ];
  late String _selectedStatus = status[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Resident Application List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_none_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filter the Student Application'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = status[0];
                            });
                            Navigator.pop(context);
                          },
                          child: Text(status[0]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = status[1];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(status[1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus = status[2];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(status[2]),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('Cancel'),
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: filter(_selectedStatus),
    );
  }

  Widget filter(String selectedStatus) {
    print(_selectedStatus);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _allApplication.length,
            itemBuilder: (context, index) {
              DocumentSnapshot user = _allApplication[index];

              if (user['status'] == selectedStatus) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    tileColor: Colors.grey,
                    title: Text(user['email'] ?? 'No Email'),
                    subtitle: Text(user['name'] + ' ' + user['student_id']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationDetail(user: user),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          );
  }
}

class ApplicationDetail extends StatefulWidget {
  final DocumentSnapshot user;

  const ApplicationDetail({required this.user, Key? key}) : super(key: key);

  @override
  State<ApplicationDetail> createState() => _ApplicationDetailState();
}

class _ApplicationDetailState extends State<ApplicationDetail> {
  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allApplication = snapshot.docs;
      _isLoading = false;
    });
  }

  void _openNewPage(DocumentSnapshot user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Room(user: user),
      ),
    );
  }

  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('room_available');

  late String statusDecline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approve page'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'The Student Resident Profile',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Center(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: MySmallText(
                            text: "Name: " +
                                widget.user['name'] +
                                "\nStudent ID: " +
                                widget.user['student_id'] +
                                "\nStudent Email: " +
                                widget.user['email'] +
                                "\nGender: " +
                                widget.user['gender'] +
                                "\nParent Name: " +
                                widget.user['parent_name'] +
                                "\nRelationship: " +
                                widget.user['relationship'] +
                                "\nParent Email: " +
                                widget.user['parent_email'] +
                                "\nRoom Type: " +
                                widget.user['room_type']),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _openNewPage(widget.user);
                          },
                          child: Text('Choose Room')),
                      ElevatedButton(
                          onPressed: () {
                            statusDecline = "Decline";
                            declineApplication(context, statusDecline);
                          
                          },
                          child: Text('Decline'))
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

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  declineApplication(BuildContext context, String status) async {
    try {
      String auth = widget.user.id;
      print(status);
      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(auth)
          .update({"status": status});
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }
}
