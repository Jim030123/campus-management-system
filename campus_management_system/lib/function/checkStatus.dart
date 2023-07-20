// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter/material.dart';


// import 'dart:async';

// void startBackgroundService() {
//   WidgetsFlutterBinding.ensureInitialized();

//   FlutterBackgroundService.initialize(onStart);

//   Timer.periodic(Duration(minutes: 15), (timer) {
//     checkAndUpdateStatus();
//   });
// }

// void onStart() {
//   WidgetsFlutterBinding.ensureInitialized();

//   final service = FlutterBackgroundService();

//   service.onDataReceived.listen((event) {
//     if (event["action"] == "setAsForeground") {
//       service.setForegroundMode(true);
//       return;
//     }

//     if (event["action"] == "setAsBackground") {
//       service.setForegroundMode(false);
//     }
//   });

//   Timer.periodic(Duration(minutes: 15), (timer) {
//     checkAndUpdateStatus();
//   });
// }
