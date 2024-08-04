import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:anynews/DxLoader.dart';
import 'package:anynews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:anynews/pages/ExtensionsPage.dart';
import 'package:anynews/pages/HomePage.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterDownloader.initialize(
    debug: false, // optional: set to false to disable printing logs to console (default: true)
    ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );  
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
            BlocProvider(
              create: (context) => ExtensionsBloc(
                context.read<ExtensionsRepo>(),
              ),
            ),
            BlocProvider(
              create: (context) => BottomNavBarCubit(),
            ),
          ],
          child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
            builder: (context, state) {
              return [HomePage(), ExtensionsPage()][state.curIdx];
            },
          ),
        ),
      ),
    );
  }
}


