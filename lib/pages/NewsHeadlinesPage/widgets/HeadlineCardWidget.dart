import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/blocs/NewsPage/news_page_bloc.dart';
import 'package:onews/consts/Routes.dart';
import 'package:onews/modules/NewsCard.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeadlineCardWidget extends StatelessWidget {
  NewsCard card;
  HeadlineCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    void onSelectHeadline() {
      context.read<NewsPageBloc>().add(ShowNewsPage(card,context.read<NewsCardBloc>().state.extensionInfo));
      Navigator.pushNamed(context, Routes.NewsPreviewPage);
    }

    return GestureDetector(
      onTap: onSelectHeadline,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),

        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey.withOpacity(0.3),
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: card.imgURL,
                  width: 90,
                  height: 90,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.date,
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 500)],
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    card.title.length > 60 ? card.title.substring(0,60) + "..." : card.title,
                    style: TextStyle(
                      fontVariations: [FontVariation("wght", 600)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
