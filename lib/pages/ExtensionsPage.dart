import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anynews/DxLoader.dart';
import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/modules/ExtensionInfo.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';
import 'package:anynews/widgets/BottomNavBarWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtensionsPage extends StatefulWidget {
  ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}
class _ExtensionsPageState extends State<ExtensionsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf4f4f6),
      appBar: AppBar(
        backgroundColor: Color(0xFF13a2cc),
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
      bottomNavigationBar: BottomNavBarWidget(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: TabBarView(
          controller: tabController,
          clipBehavior: Clip.none,
          children: [
            DisplayExtensionsWidget(),
            DownloadExtensionsWidget(),
          ],
        ),
      ),
    );
  }
}

class DisplayExtensionsWidget extends StatelessWidget {
  const DisplayExtensionsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsBloc, ExtensionsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              "Active Extensions:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...context
                .read<ExtensionsRepo>()
                .extensionsInfoList
                .map(
                  (info) => ExtensionPreviewCardWidget(info: info),
                )
                .toList()
          ],
        );
      },
    );
  }
}
class ExtensionPreviewCardWidget extends StatelessWidget {
  ExtensionInfo info;
  ExtensionPreviewCardWidget({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Container(
                height: 42,
                child: Image.network(info.logoURL),
              ),
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
              IconButton(onPressed: () {}, icon: Icon(Icons.preview)),
              IconButton(
                onPressed: () async => await launchUrl(Uri.parse(info.siteURL)),
                icon: Icon(
                  Icons.pageview,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DownloadExtensionsWidget extends StatelessWidget {
  const DownloadExtensionsWidget({
    super.key,
  });

  void onClick() async {

  }

  void onPermission() async {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsBloc, ExtensionsState>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => onPermission(),
              child: Text("Permission"),
            ),
            SizedBox(height: 16),


            ElevatedButton(
              onPressed: () => onClick(),
              child: Text("Download"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<ExtensionsBloc>().add(LoadExtensionsInfo()),
              child: Text("Load Extension List"),
            ),
            SizedBox(height: 16),
            state.loadState == ExtensionsLoadState.Loading
                ? CircularProgressIndicator()
                : SizedBox(),
            SizedBox(height: 16),
            ...context
                .read<ExtensionsRepo>()
                .extensionsInfoList
                .map(
                  (info) => ExtensionDownloadCardWidget(info: info),
                )
                .toList(),
          ],
        );
      },
    );
  }
}

class ExtensionDownloadCardWidget extends StatelessWidget {
  ExtensionInfo info;
  ExtensionDownloadCardWidget({
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
              Container(
                height: 42,
                child: Image.network(info.logoURL),
              ),
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
              IconButton(onPressed: () => context.read<ExtensionsBloc>().add(DownloadExtensionApk(info.apkURL)), icon: Icon(Icons.download)),
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
