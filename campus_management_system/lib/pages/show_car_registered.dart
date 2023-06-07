import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_vehicle_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ShowRegisterdCarPage extends StatelessWidget {
  ShowRegisterdCarPage({super.key});

  final user = FirebaseAuth.instance.currentUser!.uid;

  getdatafromDB() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(user)
        .collection('vehicle')
        .doc() // Use the provided document ID
        .get();

    // Access the "role" field and convert it to a string

    String name = await snapshot.get('name');
    String email = await snapshot.get('email');
    String id = await snapshot.get('id');
    return [name, email, id];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user)
            .collection("vehicle")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<DocumentSnapshot> documents = snapshot.data!.docs;
          List<Map<String, dynamic>> allData =
              []; // List to store all document data

          documents.forEach((document) {
            Map<String, dynamic>? data =
                document.data() as Map<String, dynamic>?;

            // Print the document ID and all fields
            print('Document ID: ${document.id}');
            data?.forEach((key, value) {
              print('$key: $value');
            });

            // Add the document data to the list
            if (data != null) {
              allData.add(data);
            }
          });

          return ListView.builder(
            itemCount: allData.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> documentData = allData[index];
              String vehicle_number = documentData['vehicle_number'];

              return ListTile(
                title: Text(vehicle_number),
              );
            },
          );
        },
      ),
    );
  }
}
