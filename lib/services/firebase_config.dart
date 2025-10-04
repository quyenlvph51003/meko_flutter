// import 'dart:io';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:meko_project/utils/logger.dart';
//
// class FirebaseConfig {
//   FirebaseMessaging? firebaseMessaging;
//
//   FirebaseConfig(FirebaseMessaging? firebase) {
//     firebaseMessaging = firebase;
//   }
//
//   Future initializeCrashlytics() async {
//     try {
//       await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
//
//       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//       String nameDevice = "";
//
//       if (Platform.isIOS) {
//         IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//         nameDevice = iosInfo.utsname.machine;
//       } else {
//         AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//         nameDevice = androidInfo.model;
//       }
//
//       FirebaseCrashlytics.instance.setUserIdentifier(nameDevice);
//     } catch (error) {
//       MyLogger.e("Connect firebase Error" + error.toString());
//     }
//   }
//
//   void initializeMessaging() {
//     try {
//       ///bgr
//       // _firebaseMessaging!.getInitialMessage().then((RemoteMessage? message) async {
//       //   if (message != null) {
//       //     AppLog.info("onInitMessage:  " + message.toMap().toString());
//       //
//       //
//       //   }
//       // });
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         MyLogger.i("onMessage: " + message.toMap().toString());
//         handelData(message);
//       });
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         MyLogger.i("onMessageOpenedApp: " + message.toMap().toString());
//         handelData(message);
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<String?> getToken() async {
//     try {
//       String? token = await firebaseMessaging?.getToken();
//       MyLogger.i('FirebaseToken: $token');
//       return token;
//     } catch (e) {
//       print(e);
//       return '';
//     }
//   }
//
//   void handelData(RemoteMessage message) async {}
// }
