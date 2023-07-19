import 'package:campus_management_system/components/my_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackReceived extends StatelessWidget {
  FeedbackReceived({Key? key}) : super(key: key);

  final CollectionReference studentResidentApplicationCollection =
      FirebaseFirestore.instance.collection('feedback');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        padding: EdgeInsets.all(1),
        child: StreamBuilder<QuerySnapshot>(
          stream: studentResidentApplicationCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final documents = snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot feedback = documents[index];
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
                      onPressed: () => toggleFavourite(feedbackId, isFavourite),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> toggleFavourite(String feedbackId, bool isFavourite) async {
    await studentResidentApplicationCollection.doc(feedbackId).update({
      'isFavourite': !isFavourite,
    });
  }
}
