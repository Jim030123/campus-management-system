import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_management_system/pages/management/student_application.dart';


class Room extends StatefulWidget {
  DocumentSnapshot user;

  Room({required this.user, Key? key}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  late DocumentSnapshot user;

  bool _isLoading = true;
  late List<DocumentSnapshot> _allRoom;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('room_available');

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allRoom = snapshot.docs;
      _isLoading = false;
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Container(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _allRoom.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot user = _allRoom[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.grey,
                        title: Text(user.id + user['capacity']),
                        subtitle: Text(user['capacity']),
                        trailing: ElevatedButton(
                            onPressed: () {}, child: Text('Select')),
                      ),
                    );
                  },
                ),
        ));
  }

  studentResidentApplication(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(user.id)
          .set({"room_no": 'sa'});
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }
}
