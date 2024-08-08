import 'dart:convert';

import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/consts/Routes.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalExtensionsCardWidget extends StatelessWidget {
  ExtensionInfo info;
  LocalExtensionsCardWidget({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    void onSelectExtension() async {
      context.read<NewsCardBloc>().add(SelectExtension(info));
      Navigator.pushNamed(context, Routes.NewsHeadlines);
    }

    return InkWell(
      onTap: () => onSelectExtension(),
      child: Container(
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(0, 2),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  child: CachedNetworkImage(
                      imageUrl: info.logoURL, fit: BoxFit.fill),
                ),
                SizedBox(width: 16),
                Text(
                  info.name,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // IconButton(
                // onPressed: () => onSelectExtension(),
                // icon: Icon(Icons.preview)),
                IconButton(
                  onPressed: () async =>
                      await launchUrl(Uri.parse(info.siteURL)),
                  icon: Icon(
                    Icons.pageview,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
