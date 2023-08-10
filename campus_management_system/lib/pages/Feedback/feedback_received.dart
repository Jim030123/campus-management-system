import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackReceived extends StatefulWidget {
  FeedbackReceived({Key? key}) : super(key: key);

  @override
  State<FeedbackReceived> createState() => _FeedbackReceivedState();
}

class _FeedbackReceivedState extends State<FeedbackReceived> {
  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Feedback'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () async {
              List<DocumentSnapshot> favoriteFeedbacks =
                  await getFavoriteFeedbacks();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteFeedbacksPage(
                    favoriteFeedbacks: favoriteFeedbacks,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(1),
        child: StreamBuilder<QuerySnapshot>(
          stream: feedbackCollection.snapshots(), // Fetch all feedbacks
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
                      "Describe feedback: " +
                          feedback['describe_feedback'] +
                          "\nSuppoting Evidence: " +
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

  Future<List<DocumentSnapshot>> getFavoriteFeedbacks() async {
    QuerySnapshot snapshot =
        await feedbackCollection.where('isFavourite', isEqualTo: true).get();
    return snapshot.docs;
  }

  Future<void> toggleFavourite(String feedbackId, bool isFavourite) async {
    await feedbackCollection.doc(feedbackId).update({
      'isFavourite': !isFavourite,
    });
  }
}

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
