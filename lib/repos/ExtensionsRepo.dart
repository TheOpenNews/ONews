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
          info["name"] as String,
          info["siteURL"] as String,
          Urls.ExtensionApkDir + "/" + info["logoURL"] as String,
          info["apk"] as String,
          "",
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
      localExtensions.add(ExtensionInfo(key, "",
          Urls.ExtensionApkDir + "/" + value["logoURL"] as String, "", "",
          categories: categories, version: value["version"] as String));
    });
  }
}
