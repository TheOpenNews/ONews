import 'dart:io';

import 'package:anynews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:anynews/blocs/NewsCard/news_card_bloc.dart';
import 'package:anynews/blocs/Permission/permission_cubit.dart';
import 'package:anynews/consts/Paths.dart';
import 'package:anynews/pages/NewsHeadlinesPage/NewsHeadlinesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:anynews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:anynews/pages/ExtensionsPage/ExtensionsPage.dart';
import 'package:anynews/pages/HomePage.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  Paths.init();

  runApp(anynews());
}

class anynews extends StatelessWidget {
  anynews({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Any News',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => ExtensionsRepo(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => BottomNavBarCubit()),
            BlocProvider(create: (context) => PermissionCubit()),
            BlocProvider(create: (context) => ExtensionDownloadBloc()),
            BlocProvider(create: (context) => NewsCardBloc()),
            BlocProvider(create: (context) => ExtensionsBloc(context.read<ExtensionsRepo>())),
            
          ],
          child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
            builder: (context, state) {
              return [HomePage(), ExtensionsPage(),NewsHeadlinesPage()][state.curIdx];
            },
          ),
        ),
      ),
    );
  }
}
