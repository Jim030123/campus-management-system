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

  Future<void> toggleFavourite(String feedbackId, bool isFavourite) async {
    await studentResidentApplicationCollection.doc(feedbackId).update({
      'isFavourite': !isFavourite,
    });
    fetchUsers();
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
                  String feedbackId = feedback.id;
                  bool isFavourite = feedback['isFavourite'] ?? false;

                  return Container(
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      tileColor: Colors.grey,
                      title: Text(feedback['feedback_type']),
                      subtitle: Text(
                        "Descibe feedback: " +
                            feedback['describe_feedback'] +
                            "\nSuppoting Evidence :" +
                            feedback['supporting_evidence'] +
                            "\n" +
                            feedback['timestamp'],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: isFavourite ? Colors.red : null,
                        ),
                        onPressed: () =>
                            toggleFavourite(feedbackId, isFavourite),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
