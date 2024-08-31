import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:onews/consts/DateFormat.dart';

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

  List<MapEntry<ContentType, String>> content;

  PreviewNewsData({
    required this.content,
    this.title = "",
    this.author = "",
    this.author_link = "",
    this.date = "",
    this.thumbnail = "",
  });

  factory PreviewNewsData.parseNative(Map? map) {
    PreviewNewsData news = PreviewNewsData(content: []);

Map header = map!["header"] as Map;
    news.title = header["title"] ?? "";
    news.thumbnail = header["img"] ?? "";
    news.author = header["author"] ?? "";
    news.author_link = header["author_link"] ?? "";
    news.date = DDateFormat.parseDate(header["date"] ?? "");

    List content = map!["content"] as List;
    content.forEach((item) {
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

  @override
  List<Object?> get props => [
        title,
        thumbnail,
        author,
        author_link,
        date,
        content,
      ];
}
