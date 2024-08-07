import 'package:anynews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:anynews/blocs/Permission/permission_cubit.dart';
import 'package:anynews/modules/ExtensionInfo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadExtensionsCardWidget extends StatelessWidget {
  ExtensionInfo info;
  DownloadExtensionsCardWidget({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  imageUrl : info.logoURL,
                    fit: BoxFit.fill
                ),
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
          SizedBox(width: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<PermissionCubit, PermissionState>(
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      if (state.packagePermission && state.packagePermission) {
                        context.read<ExtensionDownloadBloc>().add(
                            DownloadExtensionApk(info.apkURL, info.apkName));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Please give permission to download and install extensions"),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      (!state.packagePermission || !state.storagePermission)
                          ? Icons.download_outlined
                          : Icons.download,
                    ),
                  );
                },
              ),
              IconButton(
                  onPressed: () async =>
                      await launchUrl(Uri.parse(info.siteURL)),
                  icon: Icon(Icons.pageview)),
            ],
          ),
        ],
      ),
    );
  }
}
