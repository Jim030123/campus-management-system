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
        builder: (context) => ApplicationDetail(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Application List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _allApplication.length,
              itemBuilder: (context, index) {
                DocumentSnapshot user = _allApplication[index];
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    tileColor: Colors.grey,
                    title: Text(user['email'] ?? 'No Email'),
                    subtitle: Text(user.id),
                    onTap: () => _openNewPage(user),
                  ),
                );
              },
            ),
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
                      ElevatedButton(
                          onPressed: () {
                            _openNewPage(widget.user);
                          },
                          child: Text('Choose'))
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

  s() {
    if (widget.user['room_type'] == null) {
      return Text('a');
    } else if (widget.user['room_type'] ==
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
