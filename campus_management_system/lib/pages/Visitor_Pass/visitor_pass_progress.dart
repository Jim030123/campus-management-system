import 'package:campus_management_system/components/my_appbar.dart';
import 'package:flutter/material.dart';

import '../../components/my_progress.dart';

class VisitorPassProgress extends StatefulWidget {
  const VisitorPassProgress({super.key});

  @override
  State<VisitorPassProgress> createState() => _VisitorPassProgressState();
}

class _VisitorPassProgressState extends State<VisitorPassProgress> {
  late List<String> progress = ['start', 'approve', 'decline'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: ListView.builder(
        itemCount: progress.length,
        itemBuilder: (context, index) {
          final item = progress.elementAt(progress.length - 1 - index);

          if (item == 'start') {
            return VP_Progress_start();
          } else if (item == 'approve') {
            return VP_Progress_Approve();
          } else if (item == 'decline') {
            return VP_Progress_Decline();
          }
        },
      ),
    );
  }
}
