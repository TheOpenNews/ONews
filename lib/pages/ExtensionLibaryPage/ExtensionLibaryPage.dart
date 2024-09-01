import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/Ui/CustomAppBarWidget.dart';
import 'package:onews/cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/ExtensionManager/extension_manager_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/pages/ExtensionLibaryPage/widgets/LibaryExtensionCardWidget.dart';
import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:onews/repos/ExtensionsRepo.dart';

class ExtensionLibaryPage extends StatefulWidget {
  ExtensionLibaryPage({super.key});

  @override
  State<ExtensionLibaryPage> createState() => _ExtensionLibaryPageState();
}

class _ExtensionLibaryPageState extends State<ExtensionLibaryPage> {
  void onLoadLocalExtensions() async {
    context.read<ExtensionManagerBloc>().add(LoadLocalExtension());
  }

  @override
  void initState() {
    super.initState();
    if (context.read<ExtensionsRepo>().localExtensions.length == 0) {
      onLoadLocalExtensions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionManagerBloc, ExtensionManagerState>(
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarWidget(
          actions: [
            IconButton(
              onPressed: onLoadLocalExtensions,
              icon: Icon(
                Icons.restart_alt,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: (() {
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
                            (info) => LibaryExtensionCardWidget(
                              info: info,
                              onReloadExtension: onLoadLocalExtensions,
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
}