import 'package:campus_management_system/pages/resident_room.dart';
import 'package:flutter/material.dart';

class MyTestPage extends StatelessWidget {
  
   MyTestPage({super.key});



  @override
  Widget build(BuildContext context) {
      ResidentRoom residentRoom = ResidentRoom();


    return Scaffold(body: Text(residentRoom.test1(12).toString()));
  }
}
