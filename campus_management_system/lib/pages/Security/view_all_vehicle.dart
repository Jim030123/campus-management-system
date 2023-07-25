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
  late String _selectedSRStatus = status[0];

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
                          child: Text(status[1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedSRStatus = status[2];
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
        padding: EdgeInsets.all(1),
        child: StreamBuilder<QuerySnapshot>(
          stream: VehicleRegisteredCollection.where('status',
                  isEqualTo: _selectedSRStatus)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final _allCarRegistered = snapshot.data!.docs;

              return ListView.builder(
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
                            vehicle['vehicle_number'],
                      ),
                      trailing: Text(vehicle['status']),
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
                },
              );
            }
          },
        ),
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
                        child: MySmallText(text: "Name: " + widget.user['name']+
                            "\nID: " +
                            widget.user['user_id'] 
                            // "\nEmail: " +
                            // widget.user['email'] +
                            // "\nVehicle Brand " +
                            // widget.user['vehicle_brand'] +
                            // "\nVehicle Model: " +
                            // widget.user['vehicle_model'] +
                            // "\nVehicle Number: " +
                            // widget.user['vehicle_number']

                            ),
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
    // pop the loading circle
  }
}
