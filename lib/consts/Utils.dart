import 'package:flutter/cupertino.dart';
import 'package:onews/modules/HeadlineCard.dart';

class Utils {
  static List<HeadlineCard> parseJsonDataToHeadlines(List<Object?> data) {
    List<HeadlineCard> headlines = [];
    for (var i = 0; i < data.length; i++) {
      Map<String, String> cardData = Map();
      var card = data[i];
      (card as Map).forEach((key, value) {
        cardData[key] = value as String;
      });
      headlines.add(HeadlineCard.fromMap(cardData));
    }
    return headlines;
  }

  static List<FontVariation> setFontWeight(double weight) {
    return [FontVariation("wght", weight)];
  }
}
