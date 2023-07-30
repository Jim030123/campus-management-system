import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late int numOfStudent = 0;
  late int numOfVisitor = 0;
  late int numOfManagement = 0;
  late int numOfUser = 0;
  late int numOfFeedback = 0;
  late int numOfFeedbackA = 0;
  late int numOfFeedbackB = 0;
  late int numOfFeedbackC = 0;
  late int numOfFeedbackD = 0;

  late int numOfSR = 0;
  late int numOfSRA = 0;
  late int numOfSRB = 0;
  late int numOfSRC = 0;
  late int numOfSRD = 0;

  final _feedbacktype = [
    'Academic-related issue',
    'Residential facilities concern',
    'Staff or resident behavior',
    'Safety and security concern'
  ];

  final _roomtype = [
    'Twin Sharing (Air Conditioned) (Block A & C)',
    'Twin Sharing (Non Air Conditioned) (Block B & D)',
    'Twin Sharing (Air Conditioned) (Block E)',
    'Trio Sharing (Air Conditioned) (Block E)'
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: MyLargeText(text: "Management Dashboard"),
              ),
              MyDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.amber,
                    ),
                    height: 50,
                    child: Text("Total of user: " + numOfUser.toString()),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.green,
                    ),
                    height: 50,
                    child:
                        Text("Total of Feedback: " + numOfFeedback.toString()),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Colors.blue,
                    ),
                    height: 50,
                    child: Text(
                        "Total of Student Resident: " + numOfSR.toString()),
                  ),
                ],
              ),

              SizedBox(
                height: 25,
              ),
              // User in this system
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Colors.grey,
                ),
                height: 500,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    MyMiddleText(text: "User in this system"),
                    Expanded(
                      child: Container(
                        child: PieChart(
                          PieChartData(
                            sections: userData,
                            borderData: FlBorderData(show: true),
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 25,
                      runSpacing: 25,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green),
                          child: Text("Visitor: " + numOfVisitor.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange),
                          child:
                              Text("Management: " + numOfManagement.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue),
                          child: Text("Student: " + numOfStudent.toString()),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),

// Type of Feedback
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Colors.grey,
                ),
                height: 600,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    MyMiddleText(text: "Feedback Received"),
                    Expanded(
                      child: Container(
                        child: PieChart(
                          PieChartData(
                            sections: feedbackdata,
                            borderData: FlBorderData(show: true),
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 25,
                      runSpacing: 25,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green),
                          child: Text(_feedbacktype[0] +
                              ": " +
                              numOfFeedbackA.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange),
                          child: Text(_feedbacktype[1] +
                              ": " +
                              numOfFeedbackB.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue),
                          child: Text(_feedbacktype[2] +
                              ": " +
                              numOfFeedbackC.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.red),
                          child: Text(_feedbacktype[3] +
                              ": " +
                              numOfFeedbackD.toString()),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 25,
              ),

              // Type of student resident
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                  color: Colors.grey,
                ),
                height: 700,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    MyMiddleText(text: "Student Resident"),
                    Expanded(
                      child: Container(
                        child: PieChart(
                          PieChartData(
                            sections: SRdata,
                            borderData: FlBorderData(show: true),
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 25,
                      runSpacing: 25,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.green),
                          child:
                              Text(_roomtype[0] + ": " + numOfSRA.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.orange),
                          child:
                              Text(_roomtype[1] + ": " + numOfSRB.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue),
                          child:
                              Text(_roomtype[2] + ": " + numOfSRC.toString()),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.red),
                          child:
                              Text(_roomtype[3] + ": " + numOfSRD.toString()),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              //   Container(
              //     height: 500,
              //     padding: EdgeInsets.all(16),
              //     child: Column(
              //       children: [
              //         Expanded(
              //           child: Container(
              //             color: Colors.grey,
              //             child: PieChart(
              //               PieChartData(
              //                 sections: userData,
              //                 borderData: FlBorderData(show: true),
              //                 centerSpaceRadius: 40,
              //                 sectionsSpace: 2,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

// user data
  List<PieChartSectionData> userData = [
    PieChartSectionData(
      value: 0,
      color: Colors.blue,
      title: 'Student',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.green,
      title: 'Visitor',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.orange,
      title: 'Management',
      radius: 120,
    ),
  ];

  List<PieChartSectionData> feedbackdata = [
    PieChartSectionData(
      value: 0,
      color: Colors.green,
      title: 'Academic-related issue',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.orange,
      title: 'Residential facilities concern',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.blue,
      title: 'Staff or \nresident behavior',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.red,
      title: 'Safety and \nsecurity concern',
      radius: 120,
    ),
  ];

  List<PieChartSectionData> SRdata = [
    PieChartSectionData(
      value: 0,
      color: Colors.green,
      title: 'Twin Sharing \n(Air Conditioned) \n(Block A & C)',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.orange,
      title: 'Twin Sharing \n(Non Air Conditioned) \n(Block B & D)',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.blue,
      title: 'Twin Sharing \n(Air Conditioned) \n(Block E)',
      radius: 120,
    ),
    PieChartSectionData(
      value: 0,
      color: Colors.red,
      title: 'Trio Sharing \n(Air Conditioned) \n(Block E)',
      radius: 120,
    ),
  ];

  Future<void> fetchData() async {
    try {
      final QuerySnapshot Visitor = await FirebaseFirestore.instance
          .collection('users')
          .where('roles', isEqualTo: "Visitor")
          .get();

      numOfVisitor = Visitor.size;

      final QuerySnapshot Management = await FirebaseFirestore.instance
          .collection('users')
          .where('roles', isEqualTo: "Management")
          .get();

      numOfManagement = Management.size;

      final QuerySnapshot Student = await FirebaseFirestore.instance
          .collection('users')
          .where('roles', isEqualTo: "Student")
          .get();

      numOfStudent = Student.size;

      final QuerySnapshot User =
          await FirebaseFirestore.instance.collection('users').get();

      // Set the data for the pie chart based on fetched values
      setState(() {
        userData[0] = userData[0].copyWith(value: numOfStudent.toDouble());
        userData[1] = userData[1].copyWith(value: numOfVisitor.toDouble());
        userData[2] = userData[2].copyWith(value: numOfManagement.toDouble());
      });

      final QuerySnapshot Feedback =
          await FirebaseFirestore.instance.collection('feedback').get();

      numOfFeedback = Feedback.size;

      final QuerySnapshot FeedbackA = await FirebaseFirestore.instance
          .collection('feedback')
          .where('feedback_type', isEqualTo: _feedbacktype[0])
          .get();

      numOfFeedbackA = FeedbackA.size;

      final QuerySnapshot FeedbackB = await FirebaseFirestore.instance
          .collection('feedback')
          .where('feedback_type', isEqualTo: _feedbacktype[1])
          .get();

      numOfFeedbackB = FeedbackB.size;

      final QuerySnapshot FeedbackC = await FirebaseFirestore.instance
          .collection('feedback')
          .where('feedback_type', isEqualTo: _feedbacktype[2])
          .get();

      numOfFeedbackC = FeedbackC.size;

      final QuerySnapshot FeedbackD = await FirebaseFirestore.instance
          .collection('feedback')
          .where('feedback_type', isEqualTo: _feedbacktype[3])
          .get();

      numOfFeedbackD = FeedbackD.size;

      setState(() {
        feedbackdata[0] =
            feedbackdata[0].copyWith(value: numOfFeedbackA.toDouble());
        feedbackdata[1] =
            feedbackdata[1].copyWith(value: numOfFeedbackB.toDouble());
        feedbackdata[2] =
            feedbackdata[2].copyWith(value: numOfFeedbackC.toDouble());
        feedbackdata[3] =
            feedbackdata[3].copyWith(value: numOfFeedbackD.toDouble());
      });

      final QuerySnapshot StudentResident = await FirebaseFirestore.instance
          .collection('resident_application')
          .get();

      setState(() {
        numOfVisitor = Visitor.size;
        numOfSR = StudentResident.size;
        numOfUser = User.size;
      });

      final QuerySnapshot SRA = await FirebaseFirestore.instance
          .collection('resident_application')
          .where('room_type', isEqualTo: _roomtype[0])
          .get();

      numOfSRA = SRA.size;

      final QuerySnapshot SRB = await FirebaseFirestore.instance
          .collection('resident_application')
          .where('room_type', isEqualTo: _roomtype[1])
          .get();

      numOfSRB = SRB.size;

      final QuerySnapshot SRC = await FirebaseFirestore.instance
          .collection('resident_application')
          .where('room_type', isEqualTo: _roomtype[2])
          .get();

      numOfSRC = SRC.size;

      final QuerySnapshot SRD = await FirebaseFirestore.instance
          .collection('resident_application')
          .where('room_type', isEqualTo: _roomtype[3])
          .get();

      numOfSRD = SRD.size;

      setState(() {
        SRdata[0] = SRdata[0].copyWith(value: numOfSRA.toDouble());
        SRdata[1] = SRdata[1].copyWith(value: numOfSRB.toDouble());
        SRdata[2] = SRdata[2].copyWith(value: numOfSRC.toDouble());
        SRdata[3] = SRdata[3].copyWith(value: numOfSRD.toDouble());
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
