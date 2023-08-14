import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class VisitorPassScanner extends StatefulWidget {
  const VisitorPassScanner({super.key});

  @override
  State<VisitorPassScanner> createState() => _VisitorPassScannerState();
}

DateTime timestamp = DateTime.now();

class _VisitorPassScannerState extends State<VisitorPassScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanning = false;
  String scannedData = '';

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(context),
          if (scanning) buildScannerOverlay(context),
          buildScannedDataText(context),
        ],
      ),
    );
  }

  Widget buildQRView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  Widget buildScannerOverlay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 4.0,
        ),
      ),
    );
  }

  Widget buildScannedDataText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey,
        ),
        child: InkWell(
          onTap: () {
            controller?.pauseCamera();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                scannedData,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    VPentry(scannedData);
                  },
                  child: Text("Entry")),
              ElevatedButton(
                  onPressed: () {
                    VPexit(scannedData);
                  },
                  child: Text("Exit"))
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanning = false;
        scannedData = scanData.code ?? '';
      });
    });
  }

  void VPexit(String person) async {
    try {
      print(person);
      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(person)
          .update({"exit_time": timestamp as String});

      // controller?.resumeCamera();
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }

  VPentry(String person) async {
    try {
      await FirebaseFirestore.instance
          .collection('visitor_pass_application')
          .doc(person)
          .update({"entry_time": timestamp as String});
      print(person);
      // controller?.resumeCamera();
    } on FirebaseAuthException catch (e) {
      // Handle the exception if needed
    }
  }
}
