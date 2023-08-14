import 'package:campus_management_system/components/my_appbar.dart';
import 'package:campus_management_system/components/my_divider.dart';
import 'package:campus_management_system/components/my_textstyle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackSubmitted extends StatefulWidget {
  FeedbackSubmitted({super.key});

  @override
  State<FeedbackSubmitted> createState() => _FeedbackSubmittedState();
}

class _FeedbackSubmittedState extends State<FeedbackSubmitted> {
  late Stream<QuerySnapshot> _feedbackStream;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('feedback');

  void initState() {
    super.initState();
    _feedbackStream = studentResidentApplicationCollection.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        padding: EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: studentResidentApplicationCollection
              .where('id', isEqualTo: uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            // If there's no data, display a message accordingly
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No feedback available'));
            }

            // Data is available, so display the ListView
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: MyMiddleText(text: "Feedback Submitted"),
                ),
                MyDivider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot feedback = snapshot.data!.docs[index];

                      return Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                          tileColor: Colors.grey,
                          title: Text(feedback['feedback_type']),
                          subtitle: Text("Describe Feedback: " +
                              feedback['supporting_evidence'] +
                              "\nSubmit by: " +
                              feedback['name']),
                          trailing: Text(feedback['timestamp']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
