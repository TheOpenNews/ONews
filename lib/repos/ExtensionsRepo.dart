import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:onews/consts/Urls.dart';
import 'package:onews/modules/ExtensionInfo.dart';

class ExtensionsRepo {
  List<ExtensionInfo> onlineExtensions = [];
  List<ExtensionInfo> localExtensions = [];

  ExtensionsRepo() {}
  Future<List<ExtensionInfo>> queryExtensionInfo() async {
    final dio = Dio();
    Response res = await dio.get(Urls.ExtensionInfo);
    Map jsonData = await jsonDecode(res.data);

    assert(jsonData.keys.contains("Extensions"));

    onlineExtensions = [];
    List extensionsInfo = jsonData["Extensions"];

    extensionsInfo.forEach((info) {
      onlineExtensions.add(
        ExtensionInfo(
          name: info["name"] as String,
          siteURL: info["siteURL"] as String,
          logoURL: Urls.ExtensionApkDir + "/" + info["logoURL"] as String,
          apkName: info["apk"] as String,
          base64Icon: "",
          categories: [],
          version: info["version"] as String,
        ),
      );
    });

    return onlineExtensions;
  }

  void loadLocalExtensions(Map<String, Map<String, dynamic>> data) {
    localExtensions = [];
    data.forEach((key, value) {
      List<String> categories =
          (value["categories"] as List).map((cat) => cat as String).toList();
      localExtensions.add(
        ExtensionInfo(
          name: key,
          base64Icon: "",
          logoURL: Urls.ExtensionApkDir + "/" + value["logoURL"] as String,
          apkName: "",
          siteURL: "",
          categories: categories,
          version: value["version"] as String,
        ),
      );
    });
  }
}
