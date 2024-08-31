import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onews/Ui/CircularImgWidget.dart';
import 'package:onews/blocs/DownloadExtensionApk/download_extension_apk_bloc.dart';
import 'package:onews/blocs/DownloadExtensionOverlay/download_extension_overlay_bloc.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadExtensionCardWidget extends StatelessWidget {
  ExtensionInfo info;
  Function onDownloadExtension;
  DownloadExtensionCardWidget({
    super.key,
    required this.info,
    required this.onDownloadExtension,
  });

  @override
  Widget build(BuildContext context) {
    void onDownload() {
      onDownloadExtension();
      context
          .read<DownloadExtensionApkBloc>()
          .add(StartDownloadingExtensionApk(info.apkURL, info));
      context
          .read<DownloadExtensionOverlayBloc>()
          .add(ShowDownloadingOverlay());
    }

    return Container(
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
          CircularImgWidget(imgURL: info.logoURL),
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
                onPressed: onDownload,
                icon: Icon(
                  Icons.download,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

