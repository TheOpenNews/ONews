import 'package:equatable/equatable.dart';

class NewsCard extends Equatable {
  String title;
  String date;
  String imgURL;
  String link;
  NewsCard(
    this.title,
    this.date,
    this.imgURL,
    this.link,
  ) {}

  factory NewsCard.fromMap(Map<String, String> map) {
    return NewsCard(
      map["title"] as String,
      map["date"] as String,
      map["imgURL"] as String,
      map["link"] as String,
    );
  }

  @override
  String toString() {
    return "NewsCard(title: $title, date: $date, link: ${link.substring(0, 17)}...)";
  }

  @override
  List<Object?> get props => [
        title,
        date,
        imgURL,
        link,
      ];
}

