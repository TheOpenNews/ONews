
//TODO: storage permission doesnt work on android 9
// D/permissions_handler( 1933): No permissions found in manifest for: []22
//TODO: improve error system

import 'package:flutter/services.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/News.dart';

class NativeInterface {
  static MethodChannel? _platform = null;
  static void _init() {
    if (_platform != null) return;
    _platform = MethodChannel("onews/native.interface");
  }


  // loadLocalExtensions: called to get local extensions
  // looks in devices for packages with specific name
  static Future<Map<String, Map<String, dynamic>>?> loadLocalExtensions() async {
    _init();
    var pkgInfoList =
        await _platform!.invokeMethod<Map?>("loadLocalExtensions");
    if (pkgInfoList == null) {
      return null;
    }

    // parsing out from kotlin map to more nice dart map
    Map<String, Map<String, dynamic>> data =
        Map<String, Map<String, dynamic>>();
    pkgInfoList!.forEach((key1, value) {
      data[key1.toString()] = Map<String, dynamic>();
      value.forEach((key2, value) {
        data[key1.toString()]![key2.toString()] = value;
      });
    });
    return data;
  }


  // loadNewsHeadlines: calls extension loadNewsHeadlines 
  static Future<Map<String, dynamic>> loadNewsHeadlines(ExtensionInfo info,{int count = 6, int page = 1, String category = "Politics"}) async {
    _init();
    var dataMap = await _platform!.invokeMethod<Map>("loadNewsHeadlines", {
      "extensionName": info.name,
      "type": category,
      "count": count,
      "page": page
    });

    Map<String, dynamic> out = Map<String, dynamic>();
    (dataMap as Map).forEach((key, value) {
      out[key] = value;
    });
    return out;
  }

  // scrapeHomePage: calls extension scrapeHomePage 
  static Future<Map<String, dynamic>> scrapeHomePage(ExtensionInfo info) async {
    _init();
    var dataMap = await _platform!.invokeMethod<Map>("scrapeHomePage", {"extensionName": info.name});
    Map<String, dynamic> out = Map<String, dynamic>();
    (dataMap as Map).forEach((key, value) {
      out[key] = value;
    });
    return out;
  }

  // scrapeUrl: calls extension scrapeUrl 
  static Future<News?> scrapeUrl(ExtensionInfo info, String url) async {
    _init();
    var newsPageMap = await _platform!.invokeMethod<Map>("scrapeUrl", {
      "extensionName": info.name,
      "url": url,
    });

    if (newsPageMap!.containsKey("error")) {
      return null;
    }

    return News.parseNative(newsPageMap);
  }
}
