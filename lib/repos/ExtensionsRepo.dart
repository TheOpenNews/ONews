import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:onews/consts/Urls.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/LocalExtensionInfo.dart';

class ExtensionsRepo {
  List<ExtensionInfo> onlineExtensions = [];
  List<LocalExtensionInfo> localExtensions = [];

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

}
