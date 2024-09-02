import 'dart:convert';

import 'package:onews/consts/LocalStorage.dart';
import 'package:onews/modules/News.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedNewsRepo {
  Map<String, PreviewNewsData> savedNews = {};
  SavedNewsRepo() {
    (() async {
        savedNews = await LocalStorage.loadSavedNews();
    })();
  }

  Future<void> loadSavedNews() async {
    savedNews = await LocalStorage.loadSavedNews();
  }
}
