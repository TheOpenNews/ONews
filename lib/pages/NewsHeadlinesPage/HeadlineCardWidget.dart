
import 'package:anynews/NativeInterface.dart';
import 'package:anynews/blocs/NewsPage/news_page_bloc.dart';
import 'package:anynews/consts/Routes.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:anynews/pages/NewsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeadlineCardWidget extends StatelessWidget {
  NewsCard card;
  HeadlineCardWidget({super.key, required this.card});


  @override
  Widget build(BuildContext context) {
  void onSelectHeadline() {
    context.read<NewsPageBloc>().add(ShowNewsPage(card));
    Navigator.pushNamed(context, Routes.NewsPage);
  }

    return GestureDetector(
      onTap: onSelectHeadline,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                card.date,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                card.title,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 16),
            Image.network(
              card.imgURL,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
