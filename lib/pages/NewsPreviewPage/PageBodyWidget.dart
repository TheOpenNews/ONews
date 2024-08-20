import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/blocs/NewsPage/news_page_bloc.dart';
import 'package:onews/consts/Colors.dart';
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
    return SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Stack(
            children: [
              Container(
                height: 360,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(news.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom: 48,
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: CColors.primaryBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          context.read<NewsCardBloc>().state.category,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontVariations: [FontVariation("wght", 700)],
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        context.read<NewsPageBloc>().state.card.date,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontVariations: [FontVariation("wght", 500)]),
                      ),
                      SizedBox(height: 2),
                      Text(
                        news.title,
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontVariations: [FontVariation("wght", 700)],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top:  10,left: 16,right: 16),
            margin: EdgeInsets.only(top: 360 - 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.6),
                  spreadRadius: 1,
                  offset: Offset(0, -12),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: context
                                .read<NewsCardBloc>()
                                .state
                                .extensionInfo
                                .logoURL,
                          )),
                    ),
                    SizedBox(width: 8),
                    Text(
                      context.read<NewsCardBloc>().state.extensionInfo.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontVariations: [FontVariation("wght", 500)],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                ...news.content
                    .map(
                      (elem) => mapNewsElemToUiElem(elem),
                    )
                    .toList()
              ],
            ),
          ),
        
        ],
      ),
    );
  }
}
