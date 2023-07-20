import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteFeedbacksPage extends StatelessWidget {
  final List<DocumentSnapshot> favoriteFeedbacks;

  FavoriteFeedbacksPage({required this.favoriteFeedbacks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Feedbacks'),
      ),
      body: ListView.builder(
        itemCount: favoriteFeedbacks.length,
        itemBuilder: (context, index) {
          DocumentSnapshot feedback = favoriteFeedbacks[index];

          return ListTile(
            title: Text(feedback['feedback_type']),
            subtitle: Text(
              "Describe feedback: " +
                  feedback['describe_feedback'] +
                  "\nSupporting Evidence: " +
                  feedback['supporting_evidence'] +
                  "\n" +
                  feedback['timestamp'],
            ),
          );
        },
      ),
    );
  }
}
