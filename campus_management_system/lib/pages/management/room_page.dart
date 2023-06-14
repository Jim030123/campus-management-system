import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool _isLoading = true;
  late List<DocumentSnapshot> _roomData;

  final CollectionReference roomCollection =
      FirebaseFirestore.instance.collection('room_available');

  Future<void> fetchRoomData() async {
    QuerySnapshot snapshot = await roomCollection.get();
    setState(() {
      _roomData = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRoomData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child:
    ListView.builder(
      itemCount: _roomData.length,
      itemBuilder: (context, index) {
        DocumentSnapshot room = _roomData[index];
        return ListTile(
          title: Text(room['capacity'] ??
              'No Capacity'), // Update with correct field name
          subtitle: Text('s'), // Update with correct field name
          // Add more fields here if needed
        );
      },
    ),
      ),
    );
  }
}
