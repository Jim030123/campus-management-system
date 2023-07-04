import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class VisitorPassApplicationPage extends StatefulWidget {
  VisitorPassApplicationPage({super.key});

  @override
  _VisitorPassApplicationPageState createState() =>
      _VisitorPassApplicationPageState();
}

List<String> status = ['Waiting the Management Review', 'Approved', 'Declined'];
late String _selectedVPStatus = status[0];

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
        title: Text('Visitor Pass Application List'),
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
                    title: Text('Filter the Visitor Pass Application'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVPStatus = status[0];
                            });
                            Navigator.pop(context);
                          },
                          child: Text(status[0]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVPStatus = status[1];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(status[1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVPStatus = status[2];
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
      body: filter(_selectedVPStatus),
    );
  }

  Widget filter(String selectedStatus) {
    print(_selectedVPStatus);
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
                    title: Text(user['name'] ?? 'No Email'),
                    subtitle: Text(user['reason']),
                    trailing: Text(user['timestamp']),
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
    QuerySnapshot snapshot = await visitorPassApplicationCollection.get();
    setState(() {
      _allApplication = snapshot.docs;
      _isLoading = false;
    });
  }

  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;
  final TextEditingController declinereasonController = TextEditingController();
  final CollectionReference visitorPassApplicationCollection =
      FirebaseFirestore.instance.collection('visitor_pass_available');
  var uuid = Uuid();
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
              const Align(
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
                              widget.user['nric'] +
                              "\nDate Visit: " +
                              widget.user['date_visit'] +
                              "\nTime Visit: " +
                              widget.user['time_visit'] +
                              "\nVehicle Type: " +
                              "\nReason: " +
                              widget.user['reason'] +
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
                        TextFormField(
                          controller: declinereasonController,
                          decoration:
                              InputDecoration(labelText: 'Decline Reason'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              DeclineVisitorPass(context);
                            },
                            child: Text('Decline')),
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
      String status = "Approved";

      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(widget.user.id)
          .update({"status": status, "visitorpassid": uuid.v1().toString()});
    } on FirebaseAuthException catch (e) {}
    ;

    Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    // pop the loading circle
  }

  DeclineVisitorPass(BuildContext context) async {
    try {
      String status = "Declined";

      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(widget.user.id)
          .update({
        "status": status,
        "decline_reason": declinereasonController.text
      });

      Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }
}
