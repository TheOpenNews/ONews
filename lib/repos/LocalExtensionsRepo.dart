import 'package:flutter/cupertino.dart';
import 'package:onews/NativeInterface.dart';
import 'package:onews/consts/Urls.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/LocalExtensionInfo.dart';

class LocalExtensionsRepo {
  List<LocalExtensionInfo> localExtensions = [];
  LocalExtensionsRepo() {}

  void loadLocalExtensions(Map<String, Map<String, dynamic>> data) {
    localExtensions = [];
    for (String key in data.keys) {
      List<String> categories = (data[key]!["categories"] as List)
          .map((cat) => cat as String)
          .toList();
      localExtensions.add(
        LocalExtensionInfo(
          name: key,
          logoURL: Urls.ExtensionApkDir + "/" + data[key]!["logoURL"] as String,
          siteURL: "",
          categories: categories,
          packageName: data[key]!["packageName"],
          version: data[key]!["version"] as String,
        ),
      );
    }
  }

  void subToExtension() {}

  void unSubToExtension() {}

  Future<void> deleteExtension(String packageName) async {
    await NativeInterface.deleteExtension(packageName);
  }
}
