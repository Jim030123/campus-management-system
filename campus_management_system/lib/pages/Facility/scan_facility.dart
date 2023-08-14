import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class FacilityScan extends StatefulWidget {
  const FacilityScan({super.key});

  @override
  State<FacilityScan> createState() => _FacilityScanState();
}

DateTime timestamp = DateTime.now();

class _FacilityScanState extends State<FacilityScan> {
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
              StreamBuilder<QuerySnapshot>(
                stream: facilityRetrieved(scannedData), // Provide the stream
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator while fetching data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final documents = snapshot.data?.docs ?? [];

                    // Display the retrieved data
                    return Column(
                      children: documents.map((doc) {
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;

                        return Text(
                          'Facility Name: ' +
                              data['facilityName'] +
                              "\nTime Slot: " +
                              data['timeSlot'],
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
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

  Stream<QuerySnapshot> facilityRetrieved(String facilityid) {
    try {
      final CollectionReference facilityCollection =
          FirebaseFirestore.instance.collection('bookings');

      return facilityCollection
          .where('facility_pass_id', isEqualTo: facilityid)
          .snapshots();
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      print('FirebaseAuthException: ${e.message}');
      throw e; // Rethrow the exception to indicate an error to the StreamBuilder
    } catch (error) {
      // Handle other exceptions
      print('Error: $error');
      throw error; // Rethrow the exception to indicate an error to the StreamBuilder
    }
  }
}
