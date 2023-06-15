import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoomAvailable extends StatefulWidget {
  RoomAvailable({super.key});

  @override
  State<RoomAvailable> createState() => _RoomAvailableState();
}

class _RoomAvailableState extends State<RoomAvailable> {
  bool _isLoading = true;

  late List<DocumentSnapshot> _allRoom;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('room_available');

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
          padding: EdgeInsets.all(1),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _allRoom.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot user = _allRoom[index];
                    // String studentList =
                    //     user['student_ID'] + " " + user['name'].toString();

                    return Container(
                      padding: EdgeInsets.all(8),
                      child: ListTile(
                        tileColor: Colors.grey,
                        title: Text(user['room_no']),
                        subtitle: Text("Remaining Beds: " +
                            user['current_person'].toString() +
                            " / " +
                            user['max_capacity'].toString() +
                            "\n" +
                            user['student_ID'].toString() +
                            "\n" +
                            user['name'].toString()),
                      ),
                    );
                  },
                ),
        ));
  }
}
