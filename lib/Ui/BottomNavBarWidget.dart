import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onews/cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/consts/Colors.dart';

class BottomNavBarWidget extends StatelessWidget {
  BottomNavBarWidget({
    super.key,
  });

  List navs = [
    ["assets/home.svg", "Home"],
    ["assets/discover.svg", "Libary"],
    ["assets/saved.svg", "Saved"],
    ["assets/extensions.svg", "Extensions"],
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.grey.withOpacity(0.1),
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...navs.asMap().entries.map(
                (entry) {
                  return _bottomnavBtn(
                    entry.value[0],
                    entry.value[1],
                    state.curIdx == entry.key,
                    () {
                      context.read<BottomNavBarCubit>().setIdx(entry.key);
                    },
                  );
                },
              ).toList()
            ],
          ),
        );
      },
    );
  }

  Widget _bottomnavBtn(
      String path, String text, bool selected, Function callback) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => callback(),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                !selected
                    ? path
                    : path.substring(0, path.length - 4) + "-filled.svg",
                height: 18,
                color: !selected ? Colors.black : CColors.primaryBlue,
              ),
              SizedBox(height: 4),
              ...selected
                  ? [
                      Text(
                        text,
                        style: TextStyle(
                          color: !selected ? Colors.black : CColors.primaryBlue,
                          fontSize: 12,
                          fontVariations: [FontVariation('wght', 600)],
                        ),
                      )
                    ]
                  : [SizedBox()],
            ],
          ),
        ),
      ),
    );
  }
}
