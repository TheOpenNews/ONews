import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/modules/NewsCard.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<NewsCard> cards = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _appbar_widget(),
          // bottomNavigationBar: BottomNavBarWidget(),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sorry not implemented yet",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      ":P",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: BottomNavBarWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
  AppBar _appbar_widget() {
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
      elevation: 2,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.1),
    );
  }
}
