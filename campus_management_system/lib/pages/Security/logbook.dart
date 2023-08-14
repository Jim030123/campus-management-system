import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

class LogbooksScreen extends StatefulWidget {
  @override
  _LogbooksScreenState createState() => _LogbooksScreenState();
}

class _LogbooksScreenState extends State<LogbooksScreen> {
  List<String> logbookFiles = [];

  @override
  void initState() {
    super.initState();
    fetchLogbookFiles();
  }

  void fetchLogbookFiles() async {
    try {
      final ListResult result = await FirebaseStorage.instance
          .ref()
          .child(
              'logbooks') // Replace 'logbooks' with your desired folder in Firebase Storage
          .listAll();

      setState(() {
        logbookFiles = result.items.map((item) => item.name).toList();
      });
    } catch (e) {
      print("Error fetching logbook files: $e");
    }
  }

  void viewLogbookContent(String fileName) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('logbooks/$fileName');
      final data = await ref.getData(10 * 1024 * 1024); // 10MB max size

      // Convert the Uint8List to a String using utf8.decode
      final content = utf8.decode(data!);

      // Navigate to the LogbookContentScreen to display the content
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogbookContentScreen(content: content),
        ),
      );
    } catch (e) {
      print("Error viewing logbook: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logbooks'),
      ),
      body: ListView.builder(
        itemCount: logbookFiles.length,
        itemBuilder: (context, index) {
          final fileName = logbookFiles[index];
          return Container(
            padding: EdgeInsets.all(16),
            child: ListTile(
              title: Text(fileName),
              tileColor: Colors.grey,
              onTap: () => viewLogbookContent(fileName),
            ),
          );
        },
      ),
    );
  }
}

class LogbookContentScreen extends StatelessWidget {
  final String content;

  LogbookContentScreen({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logbook Content'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ),
    );
  }
}
