import 'package:flutter/cupertino.dart';
import 'package:onews/consts/DateFormat.dart';
import 'package:equatable/equatable.dart';

class HeadlineCard extends Equatable {
  String title;
  String date;
  String imgURL;
  String link;
  HeadlineCard({
    this.title = "",
    this.date = "",
    this.imgURL = "",
    this.link = "",
  });

  factory HeadlineCard.fromMap(Map<String, String> map) {
    return HeadlineCard(
      title: map["title"] as String,
      date: DDateFormat.parseDate(map["date"] as String),
      imgURL: map["imgURL"] as String,
      link: map["link"] as String,
    );
  }

  @override
  String toString() {
    return "HeadlineCard(title: $title, date: $date, link: ${link.substring(0, 17)}...)";
  }

  @override
  List<Object?> get props => [
        title,
        date,
        imgURL,
        link,
      ];
}
