import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/pages/ExtensionsPage/widgets/DownloadExtensionCardWidget.dart';
import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:onews/repos/ExtensionsRepo.dart';

class ExtensionsPage extends StatefulWidget {
  ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  bool initDownloadIsolate = false;
  static String downloadApkIsolate = "Download-Apk-Isolate";

  @pragma('vm:entry-point')
  static void sendPortdownloadApkStatus(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName(downloadApkIsolate)!;
    send.send([id, status, progress]);
  }

  void initDownloadExtensionIsolate() {
    FlutterDownloader.registerCallback(sendPortdownloadApkStatus);
    ReceivePort recvPort = ReceivePort();
    if (!IsolateNameServer.registerPortWithName(
      recvPort.sendPort,
      downloadApkIsolate,
    )) {
      IsolateNameServer.removePortNameMapping(downloadApkIsolate);
      IsolateNameServer.registerPortWithName(
        recvPort.sendPort,
        downloadApkIsolate,
      );
    }

    recvPort.listen((message) {
      DownloadTaskStatus status = DownloadTaskStatus.values[message[1]];
      debugPrint(status.toString() + " " + message.toString());
      if (status == DownloadTaskStatus.complete) {
        context.read<ExtensionDownloadBloc>().add(CompeletedTheExtensionDownload());
        recvPort.close();
      } else if (status == DownloadTaskStatus.failed) {
        context.read<ExtensionDownloadBloc>().add(FailedTheExtensionDownload());
        recvPort.close();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initDownloadExtensionIsolate();
    if (context.read<ExtensionsBloc>().state.extensionInfo.length == 0) {
      context.read<ExtensionsBloc>().add(LoadExtensionsInfo());
    }
  }

  void reloadExtensions() {
    context.read<ExtensionsBloc>().add(LoadExtensionsInfo());
  }

  bool interentError = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExtensionDownloadBloc, ExtensionDownloadState>(
      listener: (context, state) {
        if (state.downloadStatus == ExtensionDownloadStatus.Failed) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed To Download Extension")));
        } else if (state.downloadStatus == ExtensionDownloadStatus.Completed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Extension Downloaded")));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbar_widget(),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: BlocConsumer<ExtensionsBloc, ExtensionsState>(
                    listener: (context, state) {
                      if (state.loadState == ExtensionsLoadState.Error &&
                          !interentError) {
                        setState(() {
                          interentError = true;
                        });
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Failed to extensions, check your interent connection",
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.loadState == ExtensionsLoadState.Error) {
                        return _networkError();
                      }
                      return Column(
                        children: [
                          Builder(
                            builder: (context) {
                              var extensionsList = context
                                  .read<ExtensionsRepo>()
                                  .onlineExtensions;

                              return Column(
                                children: [
                                  ...extensionsList
                                      .map(
                                        (info) => DownloadExtensionCardWidget(
                                          info: info,
                                        ),
                                      )
                                      .toList(),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          state.loadState == ExtensionsLoadState.Loading
                              ? CircularProgressIndicator()
                              : SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: BottomNavBarWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _networkError() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Network Error, Please Check your interent connection",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontVariations: [
                FontVariation("wght", 600),
              ],
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: reloadExtensions,
            child: Text(
              "Try Again",
              style: TextStyle(
                fontSize: 20,
                color: CColors.primaryBlue,
                fontVariations: [
                  FontVariation("wght", 600),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appbar_widget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ONews",
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontVariations: [FontVariation('wght', 700)],
            ),
          ),
        ],
      ),
      elevation: 2,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.1),
      actions: [
        IconButton(
          onPressed: reloadExtensions,
          icon: Icon(
            Icons.restart_alt,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
