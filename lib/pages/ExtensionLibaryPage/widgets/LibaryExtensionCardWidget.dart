import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/blocs/Permission/permission_cubit.dart';
import 'package:onews/consts/Routes.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LibaryExtensionCardWidget extends StatelessWidget {
  ExtensionInfo info;
  LibaryExtensionCardWidget({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    void selectExtension() {
      Navigator.pushNamed(context, Routes.NewsHeadlines);
      context.read<NewsCardBloc>().add(SelectExtension(info));
    }

    return GestureDetector(
      onTap: () {
        selectExtension();
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 2,
            ),
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              clipBehavior: Clip.hardEdge,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: info.logoURL,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: info.name + "\n",
                      style: TextStyle(
                        fontSize: 16,
                        fontVariations: [
                          FontVariation("wght", 600),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: info.version,
                      style: TextStyle(
                        fontSize: 12,
                        fontVariations: [
                          FontVariation("wght", 500),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () async => await launchUrl(
                    Uri.parse(
                      info.siteURL,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    "assets/site.svg",
                    width: 18,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.black.withOpacity(0.6),
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
