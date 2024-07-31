import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslimnews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.curIdx,
          onTap: (idx) {
            context.read<BottomNavBarCubit>().setIdx(idx);
          },
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Extensions",
              icon: Icon(Icons.extension),
            ),
          ],
        );
      },
    );
  }
}