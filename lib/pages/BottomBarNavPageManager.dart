import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/pages/ExtensionsPage/ExtensionsPage.dart';
import 'package:onews/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBarNavPageManager extends StatelessWidget {
  const BottomBarNavPageManager({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return [
          HomePage(),
          ExtensionsPage(),
        ][state.curIdx];
      },
    );
  }
}
