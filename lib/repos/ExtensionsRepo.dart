import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:muslimnews/consts/Urls.dart';
import 'package:muslimnews/modules/ExtensionInfo.dart';

class ExtensionsRepo {
  List<ExtensionInfo> extensionsInfoList = [];

  final dio = Dio();

  ExtensionsRepo() {}

  Future<void> loadExtensionInfoList() async {
    
    Response res = await dio.get(Urls.ExtensionInfoURL);
    Map jsonData = await jsonDecode(res.data);
    assert(jsonData.keys.contains("Extensions"));

    extensionsInfoList = [];
    List extensionsInfo = jsonData["Extensions"];
    extensionsInfo.forEach((info) {
      extensionsInfoList.add(ExtensionInfo(info["name"] as String,info["siteURL"] as String, info["logoURL"]as String));
    });

    debugPrint(extensionsInfoList.toString());
  }
}
