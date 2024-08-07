import 'dart:io';

import 'package:anynews/consts/DateFormat.dart';
import 'package:anynews/modules/ExtensionInfo.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:anynews/modules/News.dart';
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

  static Future<List<NewsCard>?> loadNewsHeadlines(ExtensionInfo info,
      {int count = 6, int page = 1, String category = "Politics"}) async {
    _init();
    var pkgInfoList = await _platform!.invokeMethod<List?>("loadNewsHeadlines", {
      "extensionName": info.name,
      "type": category,
      "count": count,
      "page": page,
    });
    if(pkgInfoList ==  null) {
      return null;
    }

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

  static Future<News?> scrapeUrl(String url) async {
    _init();
    var newsPageMap = await _platform!.invokeMethod<Map?>("scrapeUrl", {
      "extensionName": "S2JNews",
      "url": url,
    });

    if(newsPageMap == null) {
      return null;
    }

    News news = News(content: []);
    Map<String,String> header;
    (newsPageMap!["header"] as Map).entries.forEach((entry) { 
      switch(entry.key) {
        case HEADER_TITLE: news.title = entry.value; break;
        case HEADER_AUTHOR: news.author = entry.value; break;
        case HEADER_AUTHOR_LINK: news.author_link = entry.value; break;
        case HEADER_DATE: news.date = DDateFormat.DefaultDF.format(DateTime.parse(entry.value)); break;
      }
    });

    (newsPageMap!["content"] as List).forEach((item) { 
      MapEntry elem = (item as Map).entries.first;
      switch (elem.key) {
        case CONTENT_IMAGE: news.content.add(MapEntry(ContentType.img, elem.value)); break;
        case CONTENT_PARAGRAPH: news.content.add(MapEntry(ContentType.p, elem.value)); break;
      }
    });

    return news;
  }

}
