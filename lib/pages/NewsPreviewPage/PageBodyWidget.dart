
import 'package:onews/modules/News.dart';
import 'package:onews/pages/NewsPreviewPage/ImageElemWidget.dart';
import 'package:onews/pages/NewsPreviewPage/TextElemWidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageBodyWidget extends StatelessWidget {
  PageBodyWidget({
    super.key,
    required this.news,
  });


  Widget mapNewsElemToUiElem(MapEntry<ContentType, String> elem) {
    Widget widget = SizedBox();
    switch (elem.key) {
      case ContentType.img:
        widget = ImageElemWidget(
          src: elem.value,
        );
        break;
      case ContentType.p:
        widget = TextElemWidget(
          text: elem.value,
        );
        break;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: widget,
    );
  }

  News news;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                if (news.author_link != "") {
                  launchUrl(Uri.parse(news.author_link));
                }
              },
              child: Text(
                "By " + news.author,
                style: TextStyle(
                    color: news.author_link != ""
                        ? Colors.lightBlue
                        : Colors.black),
              ),
            ),
            SizedBox(height: 8),
            Text(news.date),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: [
            ...news.content
                .map(
                  (elem) => mapNewsElemToUiElem(elem),
                )
                .toList()
          ],
        ),
      ],
    );
  }
}
