import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RoomAvailable extends StatefulWidget {
  RoomAvailable({super.key});

  @override
  State<RoomAvailable> createState() => _RoomAvailableState();
}

class _RoomAvailableState extends State<RoomAvailable> {
  bool _isLoading = true;
  late List<DocumentSnapshot> _allRoomType;
  final CollectionReference RoomCollection =
      FirebaseFirestore.instance.collection('room_available');

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await RoomCollection.get();
    setState(() {
      _allRoomType = snapshot.docs; // Update the correct variable here
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  List<String> RoomType = [
    'Twin Sharing (Air Conditioned) (Block A & C)',
    'Twin Sharing (Non Air Conditioned) (Block B & D)',
    'Twin Sharing (Air Conditioned) (Block E)',
    'Trio Sharing (Air Conditioned) (Block E)'
  ];

  late String _selectedRoomType = RoomType[0];
  late String roombed1;
  late String roombed2;
  late String roombed3;

  late String roombedno;

  Stream<QuerySnapshot> roomStream() {
    return RoomCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Room Type'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedRoomType = RoomType[0];
                            });
                            Navigator.pop(context);
                          },
                          child: Text(RoomType[0]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedRoomType = RoomType[1];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(RoomType[1]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedRoomType = RoomType[2];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(RoomType[2]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedRoomType = RoomType[3];
                            });
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text(RoomType[3]),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: roomStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final roomDocs = snapshot.data?.docs ?? [];
          return filter(roomDocs, _selectedRoomType);
        },
      ),
    );
  }

  Widget filter(List<QueryDocumentSnapshot> roomDocs, String selectedRoomType) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: roomDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot room = roomDocs[index];

              if (room['room_type'] == selectedRoomType) {
                return Padding(
                  padding: EdgeInsets.all(16),
                  child: ListTile(
                    tileColor: Colors.grey,
                    title: Text(room.id + " " + room['room_type']),
                    subtitle: Text(
                      "Room Gender: " +
                          room["room_gender"] +
                          "\nCurrent Person: " +
                          room["current_person"].toString() +
                          " / " +
                          room["max_capacity"].toString() +
                          "\n" +
                          roombed(room, room["max_capacity"]).toString(),
                    ),
                    trailing: ElevatedButton(
                      child: Text("Modify"),
                      onPressed: () {
                        setbedstate(room, room["max_capacity"]);
                        numberBedInRoom(room, room["max_capacity"]);
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
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

  removeStudentfromSR(
      DocumentSnapshot room, String roomNo, String roombed) async {
    if (roombed == "1") {
      try {
        await FirebaseFirestore.instance
            .collection('room_available')
            .doc(roomNo)
            .update({
          "room_bed_1": "empty",
          "current_person": FieldValue.increment(-1),
        });
      } on FirebaseAuthException catch (e) {
        // Handle the exception
      }
// update profile status after delete
      statusUpdate(room, roombed);
    } else if (roombed == "2") {
      try {
        await FirebaseFirestore.instance
            .collection('room_available')
            .doc(roomNo)
            .update({
          "room_bed_2": "empty",
          "current_person": FieldValue.increment(-1),
        });
      } on FirebaseAuthException catch (e) {
        // Handle the exception
      }
      statusUpdate(room, roombed);
    } else if (roombed == "3") {
      try {
        await FirebaseFirestore.instance
            .collection('room_available')
            .doc(roomNo)
            .update({
          "room_bed_3": "empty",
          "current_person": FieldValue.increment(-1),
        });
      } on FirebaseAuthException catch (e) {
        // Handle the exception
      }
      statusUpdate(room, roombed);
    } else {
      print("Invalid room bed number");
    }
  }

  numberBedInRoom(DocumentSnapshot room, int sa) {
    if (sa == 2) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Student in Room'),
            content: Text("Room Bed 1: " +
                room["room_bed_1"] +
                "\nRoom Bed 2: " +
                room["room_bed_2"]),
            actions: [
              ElevatedButton(
                onPressed: roombed1 == "empty"
                    ? null
                    : () {
                        setState(() {
                          roombedno = "1";
                        });
                        removeStudentfromSR(room, room.id, roombedno);
                        Navigator.pop(context); // Close the dialog
                      },
                child: Text("Remove Room Bed 1 student"),
              ),
              ElevatedButton(
                onPressed: roombed2 == "empty"
                    ? null
                    : () {
                        setState(() {
                          roombedno = "2";
                        });
                        removeStudentfromSR(room, room.id, roombedno);
                        Navigator.pop(context); // Close the dialog
                      },
                child: Text("Remove Room Bed 2 student"),
              ),
            ],
          );
        },
      );
    } else if (sa == 3) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Student in Room'),
            content: Text("Room Bed 1: " +
                room["room_bed_1"] +
                "\nRoom Bed 2: " +
                room["room_bed_2"] +
                "\nRoom Bed 3: " +
                room["room_bed_3"]),
            actions: [
              ElevatedButton(
                onPressed: roombed1 == "empty"
                    ? null
                    : () {
                        setState(() {
                          roombedno = "1";
                        });
                        removeStudentfromSR(room, room.id, roombedno);
                        Navigator.pop(context); // Close the dialog
                      },
                child: Text("Remove Room Bed 1 student"),
              ),
              ElevatedButton(
                onPressed: roombed2 == "empty"
                    ? null
                    : () {
                        setState(() {
                          roombedno = "2";
                        });
                        removeStudentfromSR(room, room.id, roombedno);
                        Navigator.pop(context); // Close the dialog
                      },
                child: Text("Remove Room Bed 2 student"),
              ),
              ElevatedButton(
                onPressed: roombed3 == "empty"
                    ? null
                    : () {
                        setState(() {
                          roombedno = "3";
                        });
                        removeStudentfromSR(room, room.id, roombedno);
                        Navigator.pop(context); // Close the dialog
                      },
                child: Text("Remove Room Bed 3 student"),
              ),
            ],
          );
        },
      );
    }
  }

  setbedstate(DocumentSnapshot room, int sa) {
    if (sa == 2) {
      return setState(() {
        roombed1 = room["room_bed_1"];
        roombed2 = room["room_bed_2"];
      });
    } else if (sa == 3) {
      return setState(() {
        roombed1 = room["room_bed_1"];
        roombed2 = room["room_bed_2"];
        roombed3 = room["room_bed_3"];
      });
    }
  }

  // Delete and update

  statusUpdate(DocumentSnapshot room, String roombed) async {
    String uid;
    if (roombed == "1") {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(room["room_bed_1_id"])
          .get();

      uid = documentSnapshot.id;
    } else if (roombed == "2") {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(room["room_bed_2_id"])
          .get();

      uid = documentSnapshot.id;
    } else if (roombed == "3") {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(room["room_bed_3_id"])
          .get();

      uid = documentSnapshot.id;
    } else {
      uid = "";
    }

   

// delete document
    try {
      await FirebaseFirestore.instance
          .collection('resident_application')
          .doc(uid)
          .delete();
    } on FirebaseAuthException catch (e) {
      // Handle the exception
    }
  }
}
