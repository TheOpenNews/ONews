import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslimnews/DxLoader.dart';
import 'package:muslimnews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:muslimnews/blocs/Extensions/extensions_bloc.dart';
import 'package:muslimnews/modules/NewsCard.dart';
import 'package:muslimnews/pages/ExtensionsPage.dart';
import 'package:muslimnews/pages/HomePage.dart';
import 'package:muslimnews/repos/ExtensionsRepo.dart';

void main() {
  runApp(MuslimNews());
}

class MuslimNews extends StatelessWidget {
  MuslimNews({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muslim News',
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

void onClick() async {
  File dexFile = await DxLoader.loadFileFromUrl(
      "https://github.com/t-88/dex-test/raw/master/classes.dex", "test.dex");
  await DxLoader.loadClass(dexFile, "Dex__");
  await DxLoader.callMethod("Dex__", "main");
}
