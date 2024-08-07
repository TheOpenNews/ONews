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

  Future<List<ExtensionInfo>> loadExtensionInfoList() async {
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
          "",
          []
        ),
      );
    });

  return extensionsInfoList;
  }


  void loadLocalExtensions(Map<String,Map<String,dynamic>> data) { 
    localExtensions = [];
    data.forEach((key,value) {
    List<String> categories = [];
      (value["categories"] as List).forEach((cat) {
          categories.add(cat);
      });
      debugPrint(categories.toString());
      localExtensions.add(ExtensionInfo(key, value["siteURL"] as String, value["logoURL"] as String, "",value["base64Icon"] as String, categories));
    });
    debugPrint(localExtensions.toString());
  }

}
