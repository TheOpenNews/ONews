import 'package:onews/blocs/ExtensionDownload/extension_download_bloc.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/blocs/NewsPage/news_page_bloc.dart';
import 'package:onews/blocs/Permission/permission_cubit.dart';
import 'package:onews/consts/Paths.dart';
import 'package:onews/consts/Routes.dart';
import 'package:onews/pages/ExtensionLibaryPage/ExtensionLibaryPage.dart';
import 'package:onews/pages/ExtensionsPage/ExtensionsPage.dart';
import 'package:onews/pages/NewsHeadlinesPage/HeadlinePreviewPage.dart';
import 'package:onews/pages/NewsPreviewPage/NewsPreviewPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/pages/HomePage.dart';
import 'package:onews/pages/PermissionsPage.dart';
import 'package:onews/pages/SavedHeadlinesPage.dart';
import 'package:onews/repos/ExtensionsRepo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false, ignoreSsl: true);
  Paths.init();
  runApp(Onews());
}

class Onews extends StatelessWidget {
  Onews({super.key});
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
          BlocProvider(create: (context) => ExtensionsBloc(context.read<ExtensionsRepo>())),
        ],
        child: MaterialApp(
          title: 'ONews',
          theme: ThemeData(
            fontFamily: "Raleway",
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Raleway'),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.Home,
          routes: {
            Routes.Home: (context) =>
                BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
                  builder: (context, state) {
                    return [
                      HomePage(),
                      ExtensionLibaryPage(),
                      SavedHeadlinesPage(),
                      //TODO: remove this, ugly 
                      BlocBuilder<PermissionCubit, PermissionState>(
                        builder: (context, state) {
                          
                          if (!state.storagePermission || !state.packagePermission) {
                            return PermissionsPage();
                          }
                          return ExtensionsPage();
                        },
                      ),
                    ][state.curIdx];
                  },
                ),
            Routes.NewsHeadlines: (context) => HeadlinePreviewPage(),
            Routes.NewsPreviewPage: (context) => NewsPreviewPage()
          },
        ),
      ),
    );
  }
}
