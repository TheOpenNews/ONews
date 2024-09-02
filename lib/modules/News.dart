import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:onews/consts/DateFormat.dart';
import 'package:onews/consts/LocalStorage.dart';
import 'package:onews/modules/HeadlineCard.dart';
import 'package:onews/modules/LocalExtensionInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

const String HEADER_TITLE = "title";
const String HEADER_AUTHOR = "author";
const String HEADER_AUTHOR_LINK = "author-link";
const String HEADER_DATE = "date";
const String CONTENT_PARAGRAPH = "p";
const String CONTENT_IMAGE = "img";

enum ContentType { p, img }

class PreviewNewsData extends Equatable {
  String title;
  String author;
  String author_link;
  String date;
  String thumbnail;
  String url;
  String category;
  LocalExtensionInfo? ext_info;

  List<List<String>> content;

  PreviewNewsData({
    required this.content,
    this.title = "",
    this.author = "",
    this.author_link = "",
    this.date = "",
    this.thumbnail = "",
    this.url = "",
    this.category = "",
    this.ext_info = null,
  });

  factory PreviewNewsData.parseNative(Map? map,LocalExtensionInfo ext_info,String category ) {
    PreviewNewsData news = PreviewNewsData(content: []);

    Map header = map!["header"] as Map;
    news.title = header["title"] ?? "";
    news.thumbnail = header["img"] ?? "";
    news.author = header["author"] ?? "";
    news.author_link = header["author_link"] ?? "";
    news.category = category;
    
    news.url = ext_info.siteURL;
    news.date = DDateFormat.parseDate(header["date"] ?? "");
    news.ext_info = ext_info;
    
    List content = map!["content"] as List;
    content.forEach((item) {
      Map elem = (item as Map);
      switch (elem["type"]) {
        case "Paragraph":
          news.content.add([ContentType.p.toString(), elem["val"]]);
          break;
        case "Header":
          break;
        case "Img":
          news.content.add([ContentType.img.toString(), elem["val"]]);
          break;
        case "VidLink":
          break;
      }
    });

    return news;
  }

  Future<void> saveToLocalStroage() async {
    Map jsonObj = convertToJson();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String saved_news_str = prefs.getString(LocalStorage.SavedNews) ?? "{}";
    Map saved_news = jsonDecode(saved_news_str);

    if (saved_news.keys.contains(jsonObj["UUID"])) {
      saved_news.remove(jsonObj["UUID"]);
    } else {
      saved_news[jsonObj["UUID"]] = jsonEncode(jsonObj);
    }
    saved_news_str = jsonEncode(saved_news);
    prefs.setString(LocalStorage.SavedNews, saved_news_str);
  }

  Map<String, dynamic> convertToJson() {
    String UUID = LocalStorage.UuidFromString(title);
    return {
      "url": url,
      "title": title,
      "thumbnail": thumbnail,
      "author": author,
      "author_link": author_link,
      "category": category,
      "date": date,
      "content": jsonEncode(content),
      "UUID": UUID,
      "ext_info": ext_info!.convertToJson(),
    };
  }

  factory PreviewNewsData.fromJson(Map<dynamic, dynamic> data) {
    List<List<String>> content = [];
    List<dynamic> unparsedContent = jsonDecode(data["content"]);
    for (int i = 0; i < unparsedContent.length; i++) {
      content.add([unparsedContent[i][0] as String, unparsedContent[i][1] as String]);
    }

    debugPrint(data.keys.toString());
    debugPrint(data["ext_info"].toString());

    return PreviewNewsData(
      url: data["url"],
      title: data["title"],
      content: content,
      author: data["author"],
      author_link: data["author_link"],
      category: data["category"],
      date: data["date"],
      thumbnail: data["thumbnail"],
      ext_info: LocalExtensionInfo.fromJson(data["ext_info"]),
    );
  }

  HeadlineCard toCard() {
    return HeadlineCard(date: date, imgURL: thumbnail, link: url, title: title);
  }

  @override
  List<Object?> get props => [
        title,
        category,
        thumbnail,
        author,
        author_link,
        date,
        content,
        url,
      ];
}
