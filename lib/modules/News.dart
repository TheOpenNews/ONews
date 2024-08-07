import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';



const String HEADER_TITLE = "title";
const String HEADER_AUTHOR = "author";
const String HEADER_AUTHOR_LINK = "author-link";
const String HEADER_DATE = "date";
const String CONTENT_PARAGRAPH =  "p";
const String CONTENT_IMAGE =  "img";


enum ContentType { p, img }

class News extends Equatable {
  String title;
  String author;
  String author_link;
  String date;
  List<MapEntry<ContentType, String>> content;

  
  News({
    required this.content,
    this.title = "",
    this.author = "",
    this.author_link = "",
    this.date = "",
  });



  @override
  List<Object?> get props => [
        title,
        author,
        author_link,
        date,
        content,
      ];
}
