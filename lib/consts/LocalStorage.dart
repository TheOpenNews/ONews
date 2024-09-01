
import 'dart:convert';

import 'package:onews/modules/News.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalStorage {
  static String SavedNews = "saved-news";
  
  static String UuidFromString(String str) {
    return Uuid().v5(Uuid.NAMESPACE_DNS, str);
  }


  static Future<Map<String,PreviewNewsData>> loadSavedNews() async {
    Map<String,PreviewNewsData> data = {};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map local_saved_news = jsonDecode(prefs.getString(LocalStorage.SavedNews) ?? "{}");
    for(String key in local_saved_news.keys) {
      data[key] = PreviewNewsData.fromJson(jsonDecode(local_saved_news[key]));
    }

    return data;
    
  }
} 

