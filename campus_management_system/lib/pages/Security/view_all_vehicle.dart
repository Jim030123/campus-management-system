import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:campus_management_system/pages/student_resident/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewAllVehicle extends StatefulWidget {
  const ViewAllVehicle({Key? key}) : super(key: key);

  @override
  _ViewAllVehicleState createState() => _ViewAllVehicleState();
}

class _ViewAllVehicleState extends State<ViewAllVehicle> {
  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;
  final CollectionReference vehicleApplicationCollection =
      FirebaseFirestore.instance.collection('vehicle');

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await vehicleApplicationCollection.get();
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
              Icons.filter_none_outlined,
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
      body: filter(_selectedVehicleStatus),
    );
  }

  Widget filter(String selectedStatus) {
    print(_selectedVehicleStatus);
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _allApplication.length,
            itemBuilder: (context, index) {
              DocumentSnapshot vehicle = _allApplication[index];
              print(_allApplication.length);

              if (vehicle['status'] == selectedStatus) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    tileColor: Colors.grey,
                    leading: Text(vehicle.id),
                    subtitle: Text("Name: " +
                        vehicle['name'] +
                        '\nVehicle brand: ' +
                        vehicle['vehicle_brand'] +
                        "\nVehicle Model: " +
                        vehicle['vehicle_model']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ApplicationDetail(user: vehicle),
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
  bool _isLoading = true;
  late List<DocumentSnapshot> _allApplication;

  late String status;

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
                                "\nStudent ID: " +
                                widget.user['student_id'] +
                                "\nEmail: " +
                                widget.user['email'] +
                                "\nVehicle Brand " +
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
                      ElevatedButton(
                          onPressed: () {
                            status = "Approved";
                            updateStatusApplication(context, status);
                          },
                          child: Text('Approved')),
                      ElevatedButton(
                          onPressed: () {
                            status = "Decline";
                            updateStatusApplication(context, status);
                          },
                          child: Text('Declined'))
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

    try {
      String auth = widget.user.id;
      print(status);
      await FirebaseFirestore.instance
          .collection('vehicle_approved')
          .doc(auth)
          .update({"status": status});
    } on FirebaseAuthException catch (e) {}
    ;
    // pop the loading circle
  }
}
