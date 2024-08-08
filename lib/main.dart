import 'dart:io';

import 'package:onews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/blocs/NewsPage/news_page_bloc.dart';
import 'package:onews/blocs/Permission/permission_cubit.dart';
import 'package:onews/consts/Paths.dart';
import 'package:onews/consts/Routes.dart';
import 'package:onews/pages/BottomBarNavPageManager.dart';
import 'package:onews/pages/NewsHeadlinesPage/NewsHeadlinesPage.dart';
import 'package:onews/pages/NewsPreviewPage/NewsPreviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/pages/ExtensionsPage/ExtensionsPage.dart';
import 'package:onews/pages/HomePage.dart';
import 'package:onews/repos/ExtensionsRepo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  Paths.init();

  runApp(onews());
}

class onews extends StatelessWidget {
  onews({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ExtensionsRepo()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BottomNavBarCubit()),
          BlocProvider(create: (context) => PermissionCubit()),
          BlocProvider(create: (context) => ExtensionDownloadBloc()),
          BlocProvider(create: (context) => NewsCardBloc()),
          BlocProvider(create: (context) => NewsPageBloc()),
          BlocProvider(
              create: (context) =>
                  ExtensionsBloc(context.read<ExtensionsRepo>())),
        ],
        child: MaterialApp(
          title: 'Any News',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          initialRoute: Routes.Home,
          routes: {
            Routes.Home: (context) => BottomBarNavPageManager(),
            Routes.NewsHeadlines: (context) => NewsHeadlinesPage(),
            Routes.NewsPreviewPage: (context) => NewsPreviewPage()
          },
        ),
      ),
    );
  }
}
