import 'package:campus_management_system/pages/Autofill/auto_fill_form_menu.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../Security/register_vehicle_page.dart';
import '../student_resident/resident_form.dart';
import '../visitor_pass/register_visitor_pass.dart';
import 'form.dart';

class QRAutoFillFormPage extends StatefulWidget {
  int selectedbutton;

  QRAutoFillFormPage({super.key, required this.selectedbutton});
  @override
  _QRAutoFillFormPageState createState() => _QRAutoFillFormPageState();
}

class _QRAutoFillFormPageState extends State<QRAutoFillFormPage> {
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
          // 1
          if (widget.selectedbutton == 1) {
            controller?.pauseCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResidentApplicationPageM(id: scannedData),
              ),
            ).then((_) {
              // Resume camera when returning from ScannedDataPage
              controller?.resumeCamera();
            });
          }

          // 2
          else if (widget.selectedbutton == 2) {
            controller?.pauseCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationVehicleFormM(id: scannedData),
              ),
            ).then((_) {
              // Resume camera when returning from ScannedDataPage
              controller?.resumeCamera();
            });
          } else if (widget.selectedbutton == 3) {
            controller?.pauseCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterVisitorPassM(id: scannedData),
              ),
            ).then((_) {
              // Resume camera when returning from ScannedDataPage
              controller?.resumeCamera();
            });
          }
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
