import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_management_system/pages/student_resident/student_resident_application.dart';

class Room extends StatefulWidget {
  DocumentSnapshot user;

  Room({required this.user, Key? key}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  late DocumentSnapshot user;

  late String roombedno;

  bool _isLoading = true;
  late List<DocumentSnapshot> _allRoom;
  String status = "Approved";

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('room_available');

  @override
  void initState() {
    super.initState();
    fetchUsers();
    print(_selectedRoomType);
  }

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allRoom = snapshot.docs;
      _isLoading = false;
    });
  }

  late String selectedRoomNo;

  late String _selectedRoomType = widget.user['room_type'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: MyMiddleText(
                            text: 'Please Assign Room for Student')),
                  ),
                  MyDivider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allRoom.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot room = _allRoom[index];

                        if (room['room_type'] == _selectedRoomType) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: ListTile(
                              tileColor: Colors.grey,
                              title: Text(room.id + " " + room['room_type']),
                              subtitle: Text("Room Gender: " +
                                  room["room_gender"] +
                                  "\nCurrent Person: " +
                                  room["current_person"].toString() +
                                  " / " +
                                  room["max_capacity"].toString() +
                                  "\n" +
                                  roombed(room, room["max_capacity"])
                                      .toString()),
                              trailing: Column(
                                children: [button(room)],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  // Add your expanded text here
                ],
              ),
      ),
    );
  }

  assignRoom() async {
    try {
      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(widget.user.id)
          .update({
        "room_no": selectedRoomNo,
        "status": status,
        "room_bed_no": roombedno,
        "current_person": FieldValue.increment(1),
      });
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }

  confirmDialog(DocumentSnapshot<Object?> room) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("You will assign this student to a Student Residence"),
        content: Text("Student Name: " +
            widget.user['name'] +
            "\nRoom No: " +
            selectedRoomNo +
            "\n\nPlease assign Room Bed:"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                numberOfBed(room, room["max_capacity"]),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: Colors.green,
                  ),
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

  button(DocumentSnapshot room) {
    if (room['current_person'] < room['max_capacity']) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            selectedRoomNo = room['room_no'];
            confirmDialog(room);
          });
        },
        child: Text('Select'),
      );
    } else if (room['current_person'] >= room['max_capacity']) {
      return ElevatedButton(
        onPressed: null,
        child: Text('Full'),
      );
    }
  }

  roombed(DocumentSnapshot room, int sa) {
    if (sa == 2)
      return "Room bed 1: " +
          room["room_bed_1"] +
          "\nRoom bed 2: " +
          room["room_bed_2"];
    else if (sa == 3) {
      return "Room bed 1: " +
          room["room_bed_1"] +
          "\nRoom bed 2: " +
          room["room_bed_2"] +
          "\nRoom bed 3: " +
          room["room_bed_3"];
    }
  }

  numberOfBed(DocumentSnapshot room, int sa) {
    if (sa == 2) {
      return Wrap(
        spacing: 25,
        runSpacing: 25,
        children: [
          // 1
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Room Bed 1",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('room_available')
                    .doc(selectedRoomNo)
                    .update({
                  "room_no": selectedRoomNo,
                  "status": status,
                  "room_bed_1": widget.user['name'],
                  "current_person": FieldValue.increment(1),
                });
              } on FirebaseAuthException catch (e) {}
              Navigator.popUntil(context,
                  ModalRoute.withName('/student_resident_application'));
              assignRoom();
            },
          ),

          // 2
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Room Bed 2",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('room_available')
                    .doc(selectedRoomNo)
                    .update({
                  "room_no": selectedRoomNo,
                  "room_bed_2": widget.user['name'],
                  "current_person": FieldValue.increment(1),
                });
              } on FirebaseAuthException catch (e) {}
              Navigator.popUntil(context,
                  ModalRoute.withName('/student_resident_application'));
              assignRoom();
            },
          ),
        ],
      );
    } else if (sa == 3) {
      return Wrap(
        spacing: 25,
        runSpacing: 25,
        children: [
          // 1
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Room Bed 1",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('room_available')
                    .doc(selectedRoomNo)
                    .update({
                  "room_no": selectedRoomNo,
                  "room_bed_1": widget.user['name'],
                  "current_person": FieldValue.increment(1),
                });
              } on FirebaseAuthException catch (e) {}
              Navigator.popUntil(context,
                  ModalRoute.withName('/student_resident_application'));
              assignRoom();
            },
          ),

          // 2
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Room Bed 2",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('room_available')
                    .doc(selectedRoomNo)
                    .update({
                  "room_no": selectedRoomNo,
                  "room_bed_2": widget.user['name'],
                  "current_person": FieldValue.increment(1),
                });
              } on FirebaseAuthException catch (e) {}
              Navigator.popUntil(context,
                  ModalRoute.withName('/student_resident_application'));
              assignRoom();
            },
          ),

          // 3
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.green,
              ),
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Room Bed 3",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('room_available')
                    .doc(selectedRoomNo)
                    .update({
                  "room_no": selectedRoomNo,
                  "room_bed_3": widget.user['name'],
                  "current_person": FieldValue.increment(1),
                });
              } on FirebaseAuthException catch (e) {}

              Navigator.popUntil(context,
                  ModalRoute.withName('/student_resident_application'));
              assignRoom();
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
