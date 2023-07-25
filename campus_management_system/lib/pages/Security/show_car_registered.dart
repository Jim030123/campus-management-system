import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowRegisteredCarPage extends StatelessWidget {
  ShowRegisteredCarPage({super.key});

  final CollectionReference VehicleRegisteredCollection =
      FirebaseFirestore.instance.collection('vehicle');

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        padding: EdgeInsets.all(1),
        child: StreamBuilder<QuerySnapshot>(
          stream: VehicleRegisteredCollection.where('id', isEqualTo: uid)
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
