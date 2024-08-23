
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onews/modules/NewsCard.dart';

class HomeHeadlinesWidget extends StatelessWidget {
  HomeHeadlinesWidget({
    super.key,
    required this.headline,
  });
  NewsCard headline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: Container(
                  width: 320,
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        headline.imgURL,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 320,
                  height: 220,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              Positioned(
                child: Container(
                  width: 320,
                  height: 220,
                  padding: EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: headline.date + "\n",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontVariations: [FontVariation("wght", 600)])),
                      TextSpan(
                        text: headline.title.length > 60
                            ? headline.title.substring(0, 60) + "..."
                            : headline.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontVariations: [FontVariation("wght", 700)],
                        ),
                      ),
                    ])),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
