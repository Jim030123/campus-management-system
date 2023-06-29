import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckFacilityAvailable extends StatefulWidget {
  @override
  State<CheckFacilityAvailable> createState() => _CheckFacilityAvailableState();
}

class _CheckFacilityAvailableState extends State<CheckFacilityAvailable> {
  late DateTime selectedDate;

  late String time;

  late String timetext;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Set the initial date to selectedDate
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  getdatafromDB() async {
    String userid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
         // Replace with your collection name
        .collection('Basketball_court')
        .doc(selectedDate.toString().split(' ')[0])
        .get();

    String name = await snapshot.get('name');
    bool aa = await snapshot.get('aa');
    return [name, aa];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyStudentDrawer(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
                color: Colors.grey,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    // date
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text(selectedDate == null
                                ? 'Select Date'
                                : selectedDate.toString().split(' ')[0]),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                    ),

                    // time
                    FutureBuilder(
                      future: getdatafromDB(),
                      builder: (context, snapshot) {
                        List<String> dataList = snapshot.data as List<String>;
                        String name = dataList[0];
                        bool aa = dataList[1] as bool;

                        return Wrap(
                          spacing: 25,
                          runSpacing: 25,
                          children: [
                            ElevatedButton(
                              onPressed: aa
                                  ? () {
                                      time = "8am-10am";
                                    }
                                  : null,
                              child: Text('8:00 AM - 10:00 AM'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                time = "10am-12pm";
                              },
                              child: Text('10:00 AM - 12:00 PM'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                time = "12pm-2pm";
                              },
                              child: Text('12:00 PM - 2:00 PM'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                time = "2pm-4pm";
                              },
                              child: Text('2:00 PM - 4:00 PM'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                time = "4pm-6pm";
                              },
                              child: Text('4:00 PM - 6:00 PM'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
