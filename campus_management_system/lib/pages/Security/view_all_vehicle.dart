import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_divider.dart';
import '../../components/my_textstyle.dart';

class ViewAllVehicle extends StatefulWidget {
  ViewAllVehicle({super.key});

  @override
  State<ViewAllVehicle> createState() => _ViewAllVehicleState();
}

class _ViewAllVehicleState extends State<ViewAllVehicle> {
  final CollectionReference VehicleRegisteredCollection =
      FirebaseFirestore.instance.collection('vehicle');

  String uid = FirebaseAuth.instance.currentUser!.uid;

  List<String> status = [
    'Waiting the Management Review',
    'Approved',
    'Declined'
  ];
  late String _selectedVehicleStatus = status[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Application List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Filter the Vehicle Application'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVehicleStatus = status[0];
                            });
                            Navigator.pop(context);
                          },
                          child: Text(status[0]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVehicleStatus = status[1];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(status[1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedVehicleStatus = status[2];
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: VehicleRegisteredCollection.where('status',
                  isEqualTo: _selectedVehicleStatus)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No vechicle data available'));
            } else {
              final _allCarRegistered = snapshot.data!.docs;

              return Column(
                children: [
                  Container(
                    child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: MyMiddleText(
                            text: 'Vehicle Application: ' +
                                _selectedVehicleStatus)),
                  ),
                  MyDivider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allCarRegistered.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot vehicle = _allCarRegistered[index];

                        return Container(
                          padding: EdgeInsets.all(8),
                          child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(vehicle.id),
                            leading: Image.network(vehicle['photoUrl']),
                            subtitle: Text(
                              "Vehicle Brand: " +
                                  vehicle['vehicle_brand'] +
                                  "\nVehicle Model: " +
                                  vehicle['vehicle_model'] +
                                  "\nVehicle Number: " +
                                  vehicle['vehicle_number'] +
                                  declineReason(vehicle),
                            ),
                            trailing: Text(vehicle['status']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleApplicationDetail(user: vehicle),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  declineReason(DocumentSnapshot vehicle) {
    if (vehicle["status"] == "Declined") {
      return "\nDeclined Reason: " + vehicle["decline_reason"];
    } else {
      return "";
    }
  }
}

class VehicleApplicationDetail extends StatefulWidget {
  final DocumentSnapshot user;

  const VehicleApplicationDetail({required this.user, Key? key})
      : super(key: key);

  @override
  State<VehicleApplicationDetail> createState() =>
      _VehicleApplicationDetailState();
}

class _VehicleApplicationDetailState extends State<VehicleApplicationDetail> {
  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;

  late String status;

  TextEditingController declinereasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    status = widget.user['status'].toString();
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
                child: MyLargeText(
                  text: 'The Vehicle Detail',
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
                                widget.user['name'] +
                                "\nVehicle Type: " +
                                widget.user['vehicle_type'] +
                                "\nVehicle Brand: " +
                                widget.user['vehicle_brand'] +
                                "\nVehicle Model: " +
                                widget.user['vehicle_model'] +
                                "\nVehicle Number: " +
                                widget.user['vehicle_number']),
                      ),
                      MyDivider(),
                      Align(
                        alignment: Alignment.center,
                        child: MyLargeText(text: "Vehicle Photo"),
                      ),
                      MyDivider(),
                      Container(
                          width: 300,
                          child: Image.network(widget.user['photoUrl'])),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: status == "Approved"
                            ? null // If status is "Approved", set onPressed to null to disable the button
                            : () {
                                status = "Approved";
                                updateStatusApplication(context, status);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                        child: Text('Approved'),
                      ),
                      Form(
                        key:
                            _formKey, // Create a GlobalKey<FormState> to access the form's state
                        child: Column(
                          children: [
                            TextFormField(
                              controller: declinereasonController,
                              decoration:
                                  InputDecoration(labelText: 'Decline Reason'),
                              // Add a validator to check if the text field is filled or not
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a reason for declining.';
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                              onPressed: status == "Declined"
                                  ? null // Disable the button if the status is "Declined"
                                  : () {
                                      // Call the validate method to check if the TextFormField is filled or not
                                      if (_formKey.currentState!.validate()) {
                                        DeclineVehicle(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  updateStatusApplication(BuildContext context, String status) async {
    try {
      String auth = widget.user.id;
      print(status);
      await FirebaseFirestore.instance
          .collection('vehicle')
          .doc(auth)
          .update({"status": status});
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }

  DeclineVehicle(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('vehicle')
          .doc(widget.user.id)
          .update({
        "decline_reason": declinereasonController.text,
        "status": "Declined",
      });

      Navigator.popUntil(context, ModalRoute.withName('/management_main'));
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }
}
