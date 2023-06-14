import 'package:campus_management_system/pages/management/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _allApplication.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = _allApplication[index];
                return ListTile(
                  title: Text(user['email'] ?? 'No Email'),
                  subtitle: Text(user.id),
                  onTap: () => _openNewPage(user),
                );
              },
            ),
    );
  }
}

class NewPage extends StatefulWidget {
  final DocumentSnapshot user;

  const NewPage({required this.user, Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allApplication = snapshot.docs;
      _isLoading = false;
    });
  }

  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('room_available');

  void _openNewPage(DocumentSnapshot user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Room(user: user),
      ),
    );
  }

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
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Center(
                  child: Column(
                    children: [
                      Text("Name: " + widget.user['name']),
                      Text("Student ID: " + widget.user['id'] ?? 'No ID'),
                      Text("Room Type: " + widget.user['room_type']),
                      s(),
                      Text(widget.user.id),
                      ElevatedButton(onPressed: () {}, child: Text('Choose'))
                    ],
                  ),
                ),
              ),
              s(),
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

  s() {
    if (widget.user['room_type'] ==
        "Twin Sharing (Air Conditioned) (Block A & C) RM 660 (Short Semester) RM 990 (Long Semester)") {
      return Text('sa');

      // } else if (widget.user['room_type'] ==
      //     'Twin Sharing (Non Air Conditioned) (Block B & D) RM 840 (Short Semester) RM 1 260 (Long Semester)') {
      // } else if (widget.user['room_type'] ==
      //     'Twin Sharing (Air Conditioned) (Block E) RM 1 500 (Short Semester)  RM 2 250 (Long Semester)') {
      // } else if (widget.user['room_type' ==
      //     'Trio Sharing (Air Conditioned) (Block E) RM 1 050 (Short Semester)  RM 1 575 (Long Semester)']) {}
    }
  }
}
