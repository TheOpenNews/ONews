import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/ApkManager.dart';
import 'package:onews/Ui/CircularImgWidget.dart';
import 'package:onews/blocs/DownloadExtensionApk/download_extension_apk_bloc.dart';
import 'package:onews/blocs/DownloadExtensionOverlay/download_extension_overlay_bloc.dart';
import 'package:onews/blocs/ExtensionManager/extension_manager_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/consts/Utils.dart';

class DownloadExtensionOverlayWidget extends StatelessWidget {
  const DownloadExtensionOverlayWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void onCancel() {
      context
          .read<DownloadExtensionOverlayBloc>()
          .add(HideDownloadingOverlay());
    }

    void onInstall() async {
      await ApkManager.installApk(
          context.read<DownloadExtensionApkBloc>().state.ext_info!.apkName);
      context
          .read<DownloadExtensionOverlayBloc>()
          .add(HideDownloadingOverlay());
    }

    return BlocBuilder<DownloadExtensionApkBloc, DownloadExtensionApkState>(
      builder: (context, ext_state) {
        return BlocBuilder<DownloadExtensionOverlayBloc,
            DownloadExtensionOverlayState>(
          builder: (context, state) {
            return state.showOverlay
                ? Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  CircularImgWidget(
                                    imgURL: ext_state.ext_info?.logoURL ?? "",
                                  ),
                                  SizedBox(width: 8),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Downloading " + (ext_state.ext_info?.name ?? ""),
                                      style: TextStyle(
                                        fontVariations:
                                            Utils.setFontWeight(500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Container(
                                height: 4,
                                width: MediaQuery.of(context).size.width,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: (MediaQuery.of(context).size.width -
                                            32 -
                                            40) *
                                        state.status /
                                        100,
                                    decoration: BoxDecoration(
                                        color: CColors.primaryBlue),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: onCancel,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontVariations:
                                            Utils.setFontWeight(600),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        state.status != 100 ? null : onInstall,
                                    child: Text(
                                      "Install",
                                      style: TextStyle(
                                        fontVariations:
                                            Utils.setFontWeight(600),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox();
          },
        );
      },
    );
  }
}
