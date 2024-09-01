import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onews/blocs/DownloadExtensionApk/download_extension_apk_bloc.dart';
import 'package:onews/blocs/HeadlinesPage/headlines_page_bloc.dart';
import 'package:onews/consts/Utils.dart';
import 'package:onews/cubits/Permission/permission_cubit.dart';
import 'package:onews/consts/Routes.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/modules/LocalExtensionInfo.dart';
import 'package:onews/repos/LocalExtensionsRepo.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopupMenuOptions { unSub, Sub, Delete }

class LibaryExtensionCardWidget extends StatelessWidget {
  LocalExtensionInfo info;
  Function onReloadExtension;
  LibaryExtensionCardWidget({
    super.key,
    required this.info,
    required this.onReloadExtension,
  });

  @override
  Widget build(BuildContext context) {
    void onSelectPopupMenu(PopupMenuOptions option) async {
      switch (option) {
        case PopupMenuOptions.Delete: 
          await context.read<LocalExtensionsRepo>().deleteExtension(info.packageName); 
          onReloadExtension();
        break;
        case PopupMenuOptions.Sub: break;
        case PopupMenuOptions.unSub: break;
      }
      debugPrint(option.toString());
    }

    void selectExtension() {
      Navigator.pushNamed(context, Routes.NewsHeadlines);
      context.read<HeadlinesPageBloc>().add(SelectExtension(info));
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
                          fontVariations: Utils.setFontWeight(600)),
                    ),
                    TextSpan(
                      text: info.version,
                      style: TextStyle(
                          fontSize: 12,
                          fontVariations: Utils.setFontWeight(500)),
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
                PopupMenuButton<PopupMenuOptions>(
                  color: Colors.white,
                  surfaceTintColor: Color(0xFFB9B9B9),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  onSelected: onSelectPopupMenu,
                  itemBuilder: (BuildContext context) {
                    return [
                      _pop_menu_item(
                          SvgPicture.asset(
                            "assets/home-filled.svg",
                            width: 16,
                            color: Colors.black,
                          ),
                          "Subscribe",
                          PopupMenuOptions.Sub),
                      _pop_menu_item(
                          Icon(
                            Icons.delete,
                            size: 22,
                          ),
                          "Delete",
                          PopupMenuOptions.Delete),
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<PopupMenuOptions> _pop_menu_item(icon, title, value) {
    return PopupMenuItem<PopupMenuOptions>(
      value: value,
      child: Row(
        children: [
          icon,
          SizedBox(width: 14),
          Text(title),
        ],
      ),
    );
  }
}
