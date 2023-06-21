import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_management_system/pages/management/student_resident_application.dart';

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

  late String selectedValue;
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
                      return Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(user['room_no']),
                            subtitle: Text("Remaining Beds: " +
                                user['current_person'].toString() +
                                " / " +
                                user['max_capacity'].toString()),
                            trailing: button(user)),
                      );
                    })));
  }

  assignRoom() async {
    try {
      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(widget.user.id)
          .update({
        "room_no": selectedValue,
      });
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }

    try {
      await FirebaseFirestore.instance
          .collection('room_available')
          .doc(selectedValue)
          .update({"current_person": FieldValue.increment(1)});
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }

  confirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("You will assign this student to a student residence"),
        content: Text("Student Name: " +
            widget.user['name'] +
            "\nRoom No: " +
            selectedValue),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Row(
              children: [
                GestureDetector(
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(14),
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    assignRoom();
                    Navigator.popUntil(context,
                        ModalRoute.withName('/student_resident_application'));
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  button(DocumentSnapshot user) {
    if (user['current_person'] < user['max_capacity']) {
      return ElevatedButton(
          onPressed: () {
            setState(() {
              selectedValue = user['room_no'];

              confirmDialog();
            });
          },
          child: Text('Select'));
    } else if (user['current_person'] >= user['max_capacity']) {
      return ElevatedButton(
        onPressed: null,
        child: Text('Full'),
      );
      // return Container(
      //   color: Colors.blue,
      //   child: Text("full"),
      // );
    }
  }
}
