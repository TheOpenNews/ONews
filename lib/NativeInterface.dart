import 'dart:io';

import 'package:anynews/modules/ExtensionInfo.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class NativeInterface {
  static HttpClient _httpClient = new HttpClient();
  static MethodChannel? _platform = null;

  static void _init() {
    if (_platform != null) return;
    _platform = MethodChannel("anynews/native.interface");
  }

  static Future<Map<String, Map<String, String>>> loadLocalExtensions() async {
    _init();
    var pkgInfoList = await _platform!.invokeMethod<Map>("loadLocalExtensions");

    // parsing out from kotlin map to more nice dart map
    Map<String, Map<String, String>> data = Map<String, Map<String, String>>();
    pkgInfoList!.forEach((key1, value) {
      data[key1.toString()] = Map<String, String>();
      value.forEach((key2, value) {
        data[key1.toString()]![key2.toString()] = value.toString();
      });
    });
    return data;
  }

  static Future<List<NewsCard>> loadNewsHeadlines(ExtensionInfo info,{int count = 6, int page = 1, String category = "Politics"}) async {
    _init();
    var pkgInfoList = await _platform!.invokeMethod<List>("loadNewsHeadlines", {
      "extensionName": info.name,
      "type": category,
      "count": count,
      "page": page,
    });

    List<NewsCard> newsCards = [];
    pkgInfoList!.forEach((card) {
      Map<String, String> cardData = Map();
      card.forEach((key, value) {
        cardData[key] = value as String;
      });
      newsCards.add(NewsCard.fromMap(cardData));
    });
    return newsCards;
  }

  static Future<void> scrapeUrl(String url) async {
    _init();
        var pkgInfoList = await _platform!.invokeMethod<Map>("scrapeUrl", {
      "extensionName": "S2JNews",
      "url": url,
    });
    debugPrint(pkgInfoList.toString());
  }
}
