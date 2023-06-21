import 'package:campus_management_system/pages/management/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisitorPassApplicationPage extends StatefulWidget {
  const VisitorPassApplicationPage({Key? key}) : super(key: key);

  @override
  _VisitorPassApplicationPageState createState() =>
      _VisitorPassApplicationPageState();
}

class _VisitorPassApplicationPageState
    extends State<VisitorPassApplicationPage> {
  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;
  final CollectionReference visitorPassApplicationCollection =
      FirebaseFirestore.instance.collection('visitor_pass_application');

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await visitorPassApplicationCollection.get();
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
    QuerySnapshot snapshot = await visitorPassApplicationCollection.get();
    setState(() {
      _allApplication = snapshot.docs;
      _isLoading = false;
    });
  }

  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;

  final CollectionReference visitorPassApplicationCollection =
      FirebaseFirestore.instance.collection('visitor_pass_available');

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
                  'The Visitor Profile',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Name: " + widget.user['name']),
                        Text("NRIC: " + widget.user['NRIC']),
                        ElevatedButton(
                            onPressed: () {}, child: Text('Approve')),
                        ElevatedButton(onPressed: () {}, child: Text('Approve'))
                      ],
                    ),
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
}
