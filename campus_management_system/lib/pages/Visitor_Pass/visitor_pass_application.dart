import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/pages/Account/Student/student_main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../components/my_textstyle.dart';

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
        builder: (context) => VPApplicationDetail(user: user),
      ),
    );
  }

  List<String> status = [
    'Waiting the Management Review',
    'Approved',
    'Declined',
    'Expired'
  ];
  late String _selectedVPStatus = status[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor Pass Application List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
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
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVPStatus = status[3];
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
      body: Container(
        padding: EdgeInsets.all(1),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Align(
                  alignment: FractionalOffset.topLeft,
                  child: MyMiddleText(
                      text: 'Visitor Pass Application: ' + _selectedVPStatus)),
            ),
            MyDivider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: visitorPassApplicationCollection
                    .where('status', isEqualTo: _selectedVPStatus)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null ||
                      snapshot.data!.size == 0) {
                    return Center(child: Text('No have data'));
                  } else {
                    final _allVPRegistered = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: _allVPRegistered.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot VP = _allVPRegistered[index];

                        print(_allVPRegistered.length);

                        return Container(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(
                                VP['name'] + " (Reason: " + VP['reason'] + ")"),
                            subtitle: Text(
                              "Visitor Pass Type: " +
                                  VP['visitor_pass_type'] +
                                  "\nVehicle Brand: " +
                                  VP['vehicle_type'] +
                                  "\nVehicle Brand: " +
                                  VP['vehicle_brand'] +
                                  "\nVehicle Model: " +
                                  VP['vehicle_model'] +
                                  "\nVehicle Number: " +
                                  VP['vehicle_number'],
                            ),
                            trailing: Text(VP['status']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VPApplicationDetail(user: VP),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VPApplicationDetail extends StatefulWidget {
  final DocumentSnapshot user;

  const VPApplicationDetail({required this.user, Key? key}) : super(key: key);

  @override
  State<VPApplicationDetail> createState() => _VPApplicationDetailState();
}

class _VPApplicationDetailState extends State<VPApplicationDetail> {
  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await visitorPassApplicationCollection.get();
    setState(() {
      _allVPApplication = snapshot.docs;
      _isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  late List<DocumentSnapshot> _allVPApplication;
  final TextEditingController declinereasonController = TextEditingController();
  final CollectionReference visitorPassApplicationCollection =
      FirebaseFirestore.instance.collection('visitor_pass_application');

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
                  'The Visitor Pass Detail',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              MyDivider(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        visitortype(),
                        SizedBox(
                          height: 25,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              ApproveVisitorPass(context);
                            },
                            child: Text('Approved')),
                        Form(
                          key:
                              _formKey, // Create a GlobalKey<FormState> to access the form's state
                          child: Column(
                            children: [
                              TextFormField(
                                controller: declinereasonController,
                                decoration: InputDecoration(
                                    labelText: 'Decline Reason'),
                                // Add a validator to check if the text field is filled or not
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a reason for declining.';
                                  }
                                  return null;
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Call the validate method to check if the TextFormField is filled or not
                                  if (_formKey.currentState!.validate()) {
                                    DeclineVisitorPass(context);
                                  }
                                },
                                child: Text('Declined'),
                              ),
                            ],
                          ),
                        )
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
      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(widget.user.id)
          .update({
        "status": "Approved",
      });

      await FirebaseFirestore.instance
          .collection('vehicle')
          .doc(widget.user['vehicle_number'])
          .update({
        "status": "Approved",
      });
    } on FirebaseAuthException catch (e) {}
    ;

    Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    // pop the loading circle
  }

  DeclineVisitorPass(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(widget.user.id)
          .update({
        "status": "Declined",
        "decline_reason": declinereasonController.text
      });

      await FirebaseFirestore.instance
          .collection('vehicle')
          .doc(widget.user['vehicle_number'])
          .update({
        "status": "Declined",
      });

      Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }

  visitortype() {
    if (widget.user['visitor_pass_type'] == "Long Term") {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Visitor Pass type: " +
              widget.user['visitor_pass_type'] +
              "\nName: " +
              widget.user['name'] +
              "\nNRIC: " +
              widget.user['nric'] +
              "\nDate Visit: " +
              widget.user['start_date_visit'] +
              "\nTime Visit: " +
              widget.user['end_date_visit'] +
              "\nVehicle Type: " +
              "\nReason: " +
              widget.user['reason'] +
              "\nVehicle Type: " +
              widget.user['vehicle_type'] +
              "\nVehicle Plate Number: " +
              widget.user['vehicle_number'],
          style: TextStyle(fontSize: 20),
        ),
      );
    } else if (widget.user['visitor_pass_type'] == "Short Term") {
      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Name: " +
              widget.user['name'] +
              "\nNRIC: " +
              widget.user['nric'] +
              "\nDate Visit: " +
              widget.user['date_visit'] +
              "\nTime Visit: " +
              widget.user['time_visit'] +
              "\nReason: " +
              widget.user['reason'] +
              "\nVehicle Brand: " +
              widget.user['vehicle_brand'] +
              "\nVehicle Type: " +
              widget.user['vehicle_type'] +
              "\nVehicle Model: " +
              widget.user['vehicle_model'] +
              "\nVehicle Plate Number: " +
              widget.user['vehicle_number'],
          style: TextStyle(fontSize: 20),
        ),
      );
    }
  }
}
