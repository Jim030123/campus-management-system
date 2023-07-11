import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllAccountPage extends StatefulWidget {
  @override
  _UserAccountsScreenState createState() => _UserAccountsScreenState();
}

class _UserAccountsScreenState extends State<ViewAllAccountPage> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  late List<DocumentSnapshot> _allUsers;
  late List<DocumentSnapshot> _filteredUsers;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await usersCollection.get();
    setState(() {
      _allUsers = snapshot.docs;
      _filteredUsers = _allUsers;
      _isLoading = false;
    });
  }

  void filterUsers(String query) {
    List<DocumentSnapshot> filteredUsers = _allUsers.where((user) {
      String email = user['email'] ?? '';
      return email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredUsers = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Accounts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: filterUsers,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = _filteredUsers[index];
                  return ListTile(
                    title: Text(user['email'] ?? 'No Email'),
                    subtitle: Text(user.id),
                    leading: Text(user['roles']),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
