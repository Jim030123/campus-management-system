import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackReceived extends StatefulWidget {
  FeedbackReceived({super.key});

  @override
  State<FeedbackReceived> createState() => _FeedbackReceivedState();
}

class _FeedbackReceivedState extends State<FeedbackReceived> {
  bool _isLoading = true;
  int favourite = 1;

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

  bool isFavourite = false;

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

                    return Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                            tileColor: Colors.grey,
                            title: Text(feedback['feedback_type']),
                            subtitle: Text("Descibe feedback: " +
                                feedback['describe_feedback'] +
                                "\nSuppoting Evidence :" +
                                feedback['supporting_evidence'] +
                                "\n" +
                                feedback['timestamp']),
                            trailing: Container(
                              color: Colors.grey,
                              child: IconButton(
                                icon: isFavourite
                                    ? Icon(Icons.favorite, color: Colors.red)
                                    : Icon(Icons.favorite_border_outlined,
                                        color: Colors.red),
                                onPressed: () {
                                  String feedbackid = feedback.id;
                                  clickfavourite(feedbackid);
                                },
                              ),
                            )));
                  },
                ),
        ));
  }

  clickfavourite(String feedbackid) async {
    try {
      print(feedbackid);
      await FirebaseFirestore.instance
          .collection('feedback')
          .doc(feedbackid)
          .update({"favourite": 1});
    } on FirebaseAuthException catch (e) {}
    ;

    setState(() {
      isFavourite = !isFavourite;
    });

    // pop the loading circle
  }
}
