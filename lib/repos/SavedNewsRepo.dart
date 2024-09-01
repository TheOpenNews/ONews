import 'dart:convert';

import 'package:onews/consts/LocalStorage.dart';
import 'package:onews/modules/News.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedNewsRepo {
  Map<String, PreviewNewsData> savedNews = {};
  SavedNewsRepo() {
    
  }

  Future<void> loadSavedNews() async {
    savedNews.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map local_saved_news = jsonDecode(prefs.getString(LocalStorage.SavedNews) ?? "{}");
    for(String key in local_saved_news.keys) {
      savedNews[key] = PreviewNewsData.fromJson(jsonDecode(local_saved_news[key]));
    }
    
  }
}
