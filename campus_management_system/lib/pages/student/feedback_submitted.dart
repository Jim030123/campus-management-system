import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackSubmitted extends StatefulWidget {
  FeedbackSubmitted({super.key});

  @override
  State<FeedbackSubmitted> createState() => _FeedbackSubmittedState();
}

class _FeedbackSubmittedState extends State<FeedbackSubmitted> {
  bool _isLoading = true;

  late List<DocumentSnapshot> _allFeedback;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('feedback');

  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await studentResidentApplicationCollection.get();
    setState(() {
      _allFeedback = snapshot.docs;
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
                  itemCount: _allFeedback.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot feedback = _allFeedback[index];
                    // String studentList =
                    //     user['student_ID'] + " " + user['name'].toString();

                    return Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(feedback['feedback_type']),
                            subtitle: Text("descibe_feedback: " +
                                feedback['supporting_evidence'] +
                                "\n"),
                            trailing: Text(feedback['timestamp'])));
                  },
                ),
        ));
  }
}
