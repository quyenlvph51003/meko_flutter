import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';

class FunctionUtil {
  // static Future<void> getMultiPhoto() async {
  //   try {
  //     final ImagePicker imagePicker = ImagePicker();
  //     final List<XFile>? images;
  //     late PermissionStatus status;
  //     if (Platform.isAndroid) {
  //       var androidInfo = await DeviceInfoPlugin().androidInfo;
  //       var release = androidInfo.version.sdkInt;
  //
  //       if (release > 32) {
  //         await Permission.photos.request();
  //         status = await Permission.photos.status;
  //       } else {
  //         await Permission.storage.request();
  //         status = await Permission.storage.status;
  //       }
  //     } else {
  //       await Permission.photos.request();
  //       status = await Permission.photos.status;
  //     }
  //
  //     if (status.isGranted) {
  //
  //     } else {
  //       AppDialog.messages(
  //         message: 'Yêu cầu quyền truy cập ảnh!',
  //         title: 'Goto App Settings',
  //         onTapOk: () {
  //           Get.back();
  //           openAppSettings();
  //         },
  //       );
  //       return [];
  //     }
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return [];
  //   }
  // }

  static Future<void> checkPermissionPhoto({VoidCallback? callback}) async {
    try {
      late PermissionStatus status;

      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var release = androidInfo.version.sdkInt;

        if (release > 32) {
          await Permission.photos.request();
          status = await Permission.photos.status;
        } else {
          await Permission.storage.request();
          status = await Permission.storage.status;
        }
      } else {
        await Permission.photos.request();
        status = await Permission.photos.status;
      }
      if (status.isGranted) {
        callback?.call();
      } else {
        // AppDialog.messages(
        //   message: 'Yêu cầu quyền truy cập ảnh!',
        //   titleButton: 'Open AppSettings',
        //   onTapOk: () {
        //     Get.back();
        //     openAppSettings();
        //   },
        // );
      }
    } catch (e) {
      MyLogger.e(e.toString());
    }
  }
}
