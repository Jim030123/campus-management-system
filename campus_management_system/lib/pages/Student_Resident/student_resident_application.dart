import 'package:campus_management_system/components/my_divider.dart';
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
    'Paid',
    'Declined',
  ];

  late String _selectedSRStatus = status[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Resident Management'),
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
                              _selectedSRStatus = status[0];
                            });
                            Navigator.pop(context);
                          },
                          child: Text(status[0]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSRStatus = status[1];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text("Waitting for Student Make Payment"),
                        ),

                        // TODO : Waitting payment
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSRStatus = status[2];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(status[2]),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSRStatus = status[3];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(status[3]),
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
      body: filter(_selectedSRStatus),
    );
  }

  Widget filter(String selectedStatus) {
    print(_selectedSRStatus);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  child: Align(
                      alignment: FractionalOffset.topLeft,
                      child: MyMiddleText(
                          text: 'Student Resident Application: ' +
                              _selectedSRStatus)),
                ),
                MyDivider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _allApplication.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot user = _allApplication[index];
                      print(_allApplication.length);
                      if (user['status'] == selectedStatus) {
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(user['email'] ?? 'No Email'),
                            subtitle:
                                Text(user['name'] + ' ' + user['student_id']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ApplicationDetail(student: user),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

class ApplicationDetail extends StatefulWidget {
  final DocumentSnapshot student;

  const ApplicationDetail({required this.student, Key? key}) : super(key: key);

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

  _openNewPage(DocumentSnapshot student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Room(user: student),
      ),
    );
  }

  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('room_available');

  late String SRstatus;

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
              MyDivider(),
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
                                widget.student['name'] +
                                "\nStudent ID: " +
                                widget.student['student_id'] +
                                "\nStudent Email: " +
                                widget.student['email'] +
                                "\nGender: " +
                                widget.student['gender'] +
                                "\nParent Name: " +
                                widget.student['parent_name'] +
                                "\nRelationship: " +
                                widget.student['relationship'] +
                                "\nParent Email: " +
                                widget.student['parent_email'] +
                                "\nRoom Type: " +
                                widget.student['room_type'] +
                                "\nStatus: " +
                                widget.student['status']),
                      ),
                      ElevatedButton(
                          onPressed: (widget.student['status'] !=
                                  'Waiting the Management Review')
                              ? null
                              : () {
                                  SRstatus = "Approved";
                                  updateSRApplicationStatus(context, SRstatus);
                                  Navigator.pop(context);
                                },
                          child: Text('Approved')),
                      ElevatedButton(
                          onPressed: (widget.student['status'] !=
                                  'Waiting the Management Review')
                              ? null
                              : () {
                                  SRstatus = "Declined";
                                  updateSRApplicationStatus(context, SRstatus);
                                  Navigator.pop(context);
                                },
                          child: Text('Decline')),
                      ElevatedButton(
                          onPressed: (widget.student['status'] != 'Approved')
                              ? null
                              : () {
                                  SRstatus = "Paid";
                                  updateSRApplicationStatus(context, SRstatus);
                                  Navigator.pop(context);
                                },
                          child: Text('Paid')),
                      ElevatedButton(
                        onPressed: (widget.student['status'] != 'Paid')
                            ? null
                            : () {
                                _openNewPage(widget.student);

                              },
                        child: Text('Choose Room'),
                      )
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

  updateSRApplicationStatus(BuildContext context, String status) async {
    try {
      String auth = widget.student.id;
      print(status);
      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(auth)
          .update({
        "status": status,
       
      });
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }
}
