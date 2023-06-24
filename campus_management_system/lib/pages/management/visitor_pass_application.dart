import 'package:campus_management_system/pages/management/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VisitorPassApplicationPage extends StatefulWidget {
  VisitorPassApplicationPage({super.key});

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
                        Text(
                          "Name: " +
                              widget.user['name'] +
                              "\nNRIC: " +
                              widget.user['NRIC'] +
                              "\nStatus: " +
                              widget.user['status'] +
                              "\nDate Visit: " +
                              widget.user['date_visit'] +
                              "\nVehicle Type: " +
                              widget.user['vehicle_type'] +
                              "\nVehicle Plate Number: " +
                              widget.user['vehicle_plate_number'],
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ApproveVisitorPass(context);
                            },
                            child: Text('Approve')),
                        ElevatedButton(
                            onPressed: () {
                              DeclineVisitorPass(context);
                            },
                            child: Text('Decline'))
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

  ApproveVisitorPass(BuildContext context) async {
    try {
      String status = "Approve";

      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(widget.user.id)
          .update({"status": status});
    } on FirebaseAuthException catch (e) {}
    ;

    Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    // pop the loading circle
  }

  DeclineVisitorPass(BuildContext context) async {
    try {
      String status = "Decline";

      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(widget.user.id)
          .update({"status": status});

      Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }
}
