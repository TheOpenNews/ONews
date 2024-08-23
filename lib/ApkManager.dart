
import 'dart:io';

import 'package:onews/consts/Paths.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';

class ApkManager {
  //TODO: create a utils class
  static void deleteFileIfExists(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  //TODO: do smth with the output
  static Future<bool> downloadApk(String apkName, String apkURL) async {
    deleteFileIfExists("${Paths.ApplicationDownloadDir}/$apkName");
    var _ = await FlutterDownloader.enqueue(
      url: apkURL,
      headers: {},
      savedDir: Paths.ApplicationDownloadDir,
      showNotification: true,
      fileName: apkName,
    );
    return false;
  }

  //TODO: do smth with the output
  static Future<bool> installApk(apkName) async {
    String filePath = "${Paths.ApplicationDownloadDir}/$apkName";


    File file = File(filePath);
    if (!(await file.exists())) {
      return false;
    }

    final FlutterAppInstaller flutterAppInstaller = FlutterAppInstaller();
    var _ = await flutterAppInstaller.installApk(
      filePath: filePath,
    );
    return false;
  }
}
