import 'dart:io';

import 'package:onews/consts/DateFormat.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/NewsCard.dart';
import 'package:onews/modules/News.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class NativeInterface {
  static HttpClient _httpClient = new HttpClient();
  static MethodChannel? _platform = null;

  static void _init() {
    if (_platform != null) return;
    _platform = MethodChannel("onews/native.interface");
  }

  static Future<Map<String, Map<String, dynamic>>?>
      loadLocalExtensions() async {
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

  static Future<Map<String, dynamic>> loadNewsHeadlines(ExtensionInfo info,
      {int count = 6, int page = 1, String category = "Politics"}) async {
    _init();
    var dataMap = await _platform!.invokeMethod<Map>("loadNewsHeadlines", {
      "extensionName": info.name,
      "type": category,
      "count": count,
      "page": page
    });

    debugPrint("loadNewsHeadlines: " + dataMap.toString());

    Map<String, dynamic> out = Map<String, dynamic>();
    (dataMap as Map).forEach((key, value) {
      out[key] = value;
    });
    return out;

    // if (dataMap!.keys.contains("error")) {
    //   return null;
    // }

    // List<NewsCard> newsCards = [];
    // var data = dataMap["data"] as List;
    // for (var i = 0; i < data.length; i++) {
    //   Map<String, String> cardData = Map();
    //   var card = data[i];
    //   card.forEach((key, value) {
    //     cardData[key] = value as String;
    //   });
    //   newsCards.add(NewsCard.fromMap(cardData));
    // }
    // return newsCards;
  }

  static Future<Map<String, dynamic>> scrapeHomePage(ExtensionInfo info) async {
    _init();
    var dataMap = await _platform!
        .invokeMethod<Map>("scrapeHomePage", {"extensionName": info.name});
    debugPrint("scrapeHomePage: " + dataMap.toString());
    Map<String, dynamic> out = Map<String, dynamic>();
    (dataMap as Map).forEach((key, value) {
      out[key] = value;
    });

    return out;

    // List<NewsCard> newsCards = [];
    // var data = dataMap["data"] as List;
    // for (var i = 0; i < data.length; i++) {
    //   Map<String, String> cardData = Map();
    //   var card = data[i];
    //   card.forEach((key, value) {
    //     cardData[key] = value as String;
    //   });
    //   newsCards.add(NewsCard.fromMap(cardData));
    // }
    // return newsCards;
  }

  static Future<News?> scrapeUrl(ExtensionInfo info, String url) async {
    _init();
    debugPrint("scrapeUrl " + info.toString() + url.toString());

    var newsPageMap = await _platform!.invokeMethod<Map>("scrapeUrl", {
      "extensionName": info.name,
      "url": url,
    });

    debugPrint(newsPageMap.toString());

    if (newsPageMap!.containsKey("error")) {
      return null;
    }

    News news = News(content: []);
    Map<String, String> header;
    (newsPageMap!["header"] as Map).entries.forEach((entry) {
      switch (entry.key) {
        case "title":
          news.title = entry.value;
          break;
        case "img":
          news.thumbnail = entry.value;
          break;
        case "author":
          news.author = entry.value;
          break;
        case "author_link":
          news.author_link = entry.value;
          break;
        case "date":
          try {
            news.date =
                DDateFormat.DefaultDF.format(DateTime.parse(entry.value));
          } catch (e) {
            news.date = entry.value;
          }
          break;
      }
    });

    (newsPageMap!["content"] as List).forEach((item) {
      Map elem = (item as Map);
      switch (elem["type"]) {
        case "Paragraph":
          news.content.add(MapEntry(ContentType.p, elem["val"]));
          break;
        case "Header":
          break;
        case "Img":
          news.content.add(MapEntry(ContentType.img, elem["val"]));
          break;
        case "VidLink":
          break;
      }
    });

    return news;
  }
}
