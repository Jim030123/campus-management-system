import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowRegisteredCarPage extends StatefulWidget {
  ShowRegisteredCarPage({super.key});

  @override
  State<ShowRegisteredCarPage> createState() => _ShowRegisteredCarPageState();
}

class _ShowRegisteredCarPageState extends State<ShowRegisteredCarPage> {
  bool _isLoading = true;

  late List<DocumentSnapshot> _allFeedback;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('vehicle');

  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allFeedback = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
          padding: EdgeInsets.all(1),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _allFeedback.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot vehicle = _allFeedback[index];

                    return Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(vehicle.id),
                            leading: Image.network(vehicle['photoUrl']),
                            subtitle: Text("Vehicle Brand: " +
                                vehicle['vehicle_brand'] +
                                "\nVehicle Model: " +
                                vehicle['vehicle_model'] +
                                "\nVehicle Number: " +
                                vehicle['vehicle_number']),
                            trailing: Text(vehicle['status'])));
                  },
                ),
        ));
  }
}
