import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> getPermission() async {
  // Check the platform
  if (Platform.isAndroid) {
    // Get the Android device information
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (await Permission.storage.isGranted ||
        await Permission.photos.isGranted) {
      return true;
    }
    // Check if the storage and photos permission is not granted
    if (!await Permission.storage.isGranted &&
        !await Permission.photos.isGranted) {
      // If the Android SDK version is less than or equal to 32, request storage permission
      // Otherwise, request photos permission
      PermissionStatus permissionStatus;
      if (androidInfo.version.sdkInt <= 32) {
        permissionStatus = await Permission.storage.request();
      } else {
        permissionStatus = await Permission.photos.request();
      }

      if (permissionStatus.isGranted) {
        return true;
      }
    }
    return false;
  } else {
    // Check the status of the photos permission
    var status = await Permission.photos.status;

    // If the permission is granted, return true
    if (status.isGranted) {
      log("Permission is granted.");
      return true;
    }
    // If the permission is permanently denied, return false
    else if (status.isPermanentlyDenied) {
      log("Permission is permanently denied.");
      return false;
    }
    // If the permission is not granted, request the permission and return the result
    else {
      status = await Permission.photos.request();
      if (status.isGranted) {
        log("Permission granted after request.");
        return true;
      } else {
        log("Permission denied after request.");
        return false;
      }
    }
  }
}
