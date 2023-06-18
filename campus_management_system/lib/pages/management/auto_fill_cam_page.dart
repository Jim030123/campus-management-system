import 'package:campus_management_system/pages/management/auto_fill_form_menu.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AutoFillFormPage extends StatefulWidget {
  @override
  _AutoFillFormPageState createState() => _AutoFillFormPageState();
}

class _AutoFillFormPageState extends State<AutoFillFormPage> {
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
    return Positioned(
      bottom: 16.0,
      child: InkWell(
        onTap: () {
          controller?.pauseCamera();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AutoFillFormMenu(scannedData: scannedData),
            ),
          ).then((_) {
            // Resume camera when returning from ScannedDataPage
            controller?.resumeCamera();
          });
        },
        child: Text(
          scannedData,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
}
