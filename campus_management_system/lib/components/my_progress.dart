import 'package:flutter/material.dart';

class VP_Progress_start extends StatelessWidget {
  const VP_Progress_start({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.yellow),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('24 MAC 2023 16:00'),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            children: [
              Text(
                'Waiting Approve',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                  'Your visitor pass sumbmitted at 16:00, the Management will review this visitor pass within 24 hour.')
            ],
          ),
        ),
        Text(
          textAlign: TextAlign.left,
          'Status: Approve',
          style: TextStyle(fontSize: 25),
        ),
      ]),
    );
  }
}

class VP_Progress_Approve extends StatelessWidget {
  const VP_Progress_Approve({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.green),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('24 MAC 2023 16:00'),
        Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            children: [
              Text(
                'Your visitor pass already approve',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                  'Your visitor pass approved by Management and click here view your visitor pass')
            ],
          ),
        ),
        Text(
          textAlign: TextAlign.left,
          'Status: Decline',
          style: TextStyle(fontSize: 25),
        ),
      ]),
    );
  }
}

class VP_Progress_Decline extends StatelessWidget {
  const VP_Progress_Decline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: Colors.red),
        padding: EdgeInsets.all(16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('24 MAC 2023 16:00'),
          Column(
            children: [
              Text(
                textAlign: TextAlign.left,
                'Your visitor pass decline',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                'Reason:',
              )
            ],
          ),
          Text(
            textAlign: TextAlign.left,
            'Status: Decline',
            style: TextStyle(fontSize: 25),
          ),
        ]),
      ),
    );
  }
}
