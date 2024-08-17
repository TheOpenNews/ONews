import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:onews/NativeInterface.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/pages/ExtensionsPage/DownloadExtensionsWidget.dart';
import 'package:onews/pages/ExtensionsPage/LocalExtensionsWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/NewsHeadlinesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/pages/ui/BottomNavBarWidget.dart';
import 'package:onews/repos/ExtensionsRepo.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtensionsPage extends StatefulWidget {
  ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage>{
  late TabController tabController;
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
      debugPrint(status.toString());
      if (status == DownloadTaskStatus.complete) {
        context
            .read<ExtensionDownloadBloc>()
            .add(CompeletedTheExtensionDownload());
        recvPort.close();
      } else if (status == DownloadTaskStatus.failed) {
        context.read<ExtensionDownloadBloc>().add(FailedTheExtensionDownload());
        recvPort.close();
      }
    });
  }

  @override
  void initState() {
    // tabController = TabController(length: 2, vsync: this);
    initDownloadExtensionIsolate();
    super.initState();
  }

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
        backgroundColor: CColors.greyWhite,
        appBar: AppBar(
          backgroundColor: CColors.lightBlue,
          title: Text(
            "Extensions",
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                child: Text(
                  "Extensions",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  "Download",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: TabBarView(
                controller: tabController,
                clipBehavior: Clip.none,
                children: [
                  LocalExtensionsWidget(),
                  DownloadExtensionsWidget(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: BottomNavBarWidget(),
            )
          ],
        ),
      ),
    );
  }
}
