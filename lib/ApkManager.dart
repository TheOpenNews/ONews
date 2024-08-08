import 'dart:async';
import 'dart:io';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:onews/consts/Paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class ApkManager {
  static void deleteFileIfExists(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<bool> downloadApk(String apkName, String apkURL) async {
    deleteFileIfExists("${Paths.ApplicationDownloadDir}/$apkName");
    var out = await FlutterDownloader.enqueue(
      url: apkURL,
      headers: {},
      savedDir: Paths.ApplicationDownloadDir,
      showNotification: true,
      fileName: apkName,
    );
    debugPrint(out);
    return false;
  }

  static Future<bool> installApk(apkName) async {
    debugPrint("-------------------------------------------");

    String filePath = "${Paths.ApplicationDownloadDir}/$apkName";
    File file = File(filePath);
    if (!(await file.exists())) {
    debugPrint("out.toString()");

      return false;
    }

    var out = await AndroidPackageInstaller.installApk(apkFilePath: filePath);
    debugPrint(out.toString());
    return false;
  }
}
