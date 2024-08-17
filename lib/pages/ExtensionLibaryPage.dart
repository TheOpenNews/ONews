import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onews/NativeInterface.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/pages/ExtensionsPage/DownloadExtensionsCardWidget.dart';
import 'package:onews/pages/ExtensionsPage/LocalExtensionsCardWidget.dart';
import 'package:onews/pages/ui/BottomNavBarWidget.dart';
import 'package:onews/repos/ExtensionsRepo.dart';

class ExtensionLibaryPage extends StatefulWidget {
  ExtensionLibaryPage({super.key});

  @override
  State<ExtensionLibaryPage> createState() => _ExtensionLibaryPageState();
}

class _ExtensionLibaryPageState extends State<ExtensionLibaryPage> {
  void loadLocalExtensions() async {
    context.read<ExtensionsBloc>().add(LoadLocalExtension());
  }

  @override
  void initState() {
    super.initState();
    if (context.read<ExtensionsRepo>().localExtensions.length == 0) {
      loadLocalExtensions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsBloc, ExtensionsState>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _appbarWidget(),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: (() {
                debugPrint("---------------------- " +
                    state.libaryLoadState.toString());
                if (state.libaryLoadState == ExtensionsLoadState.Loading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: CColors.primaryBlue,
                      ),
                    ],
                  );
                }
                if (state.libaryLoadState == ExtensionsLoadState.None &&
                    state.localExtensions.length == 0) {
                  return _noExtensions();
                }
                return Column(
                  children: [
                    Column(children: [
                      ...state.localExtensions
                          .map(
                            (info) => LocalExtensionsCardWidget(
                              info: info,
                            ),
                          )
                          .toList()
                    ]),
                  ],
                );
              })(),
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

  Column _noExtensions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "No Extensions In Libary",
          style: TextStyle(
              fontSize: 18, fontVariations: [FontVariation("wght", 600)]),
        ),
        TextButton(
          onPressed: () => context.read<BottomNavBarCubit>().setIdx(3),
          child: Text(
            "Install Extensions",
            style: TextStyle(
                fontSize: 18,
                color: CColors.primaryBlue,
                fontVariations: [FontVariation("wght", 600)]),
          ),
        ),
      ],
    );
  }

  AppBar _appbarWidget() {
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
      actions: [
        IconButton(
          onPressed: loadLocalExtensions,
          icon: Icon(
            Icons.restart_alt,
            color: Colors.grey[800],
          ),
        ),
      ],
      elevation: 2,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.1),
    );
  }
}
