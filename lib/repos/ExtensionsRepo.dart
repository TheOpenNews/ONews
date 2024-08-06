import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:anynews/consts/Urls.dart';
import 'package:anynews/modules/ExtensionInfo.dart';

class ExtensionsRepo {
  List<ExtensionInfo> extensionsInfoList = [];
  List<ExtensionInfo> localExtensions = [];

  final dio = Dio();

  ExtensionsRepo() {}

  Future<void> loadExtensionInfoList() async {
    Response res = await dio.get(Urls.ExtensionInfo);
    Map jsonData = await jsonDecode(res.data);
    assert(jsonData.keys.contains("Extensions"));
    extensionsInfoList = [];
    List extensionsInfo = jsonData["Extensions"];
    extensionsInfo.forEach((info) {
      extensionsInfoList.add(
        ExtensionInfo(
          info["name"] as String,
          info["siteURL"] as String,
          info["logoURL"] as String,
          info["apk"] as String,
          ""
        ),
      );
    });

    debugPrint(extensionsInfoList.toString());
  }


  void loadLocalExtensions(Map<String,Map<String,String>> data) { 
    localExtensions = [];
    data.forEach((key,value) {
      localExtensions.add(ExtensionInfo(key, value["siteURL"] as String, value["logoURL"] as String, "",value["base64Icon"] as String));
    });
    debugPrint(localExtensions.toString());
  }

}
