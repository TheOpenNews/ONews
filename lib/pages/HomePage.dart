import 'package:onews/NativeInterface.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/repos/ExtensionsRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/modules/NewsCard.dart';
import 'package:onews/widgets/BottomNavBarWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<NewsCard> cards = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color(0xFFf4f4f6),
          appBar: AppBar(
            backgroundColor: Color(0xFF13a2cc),
            title: Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottomNavigationBar: BottomNavBarWidget(),
          body: Container(
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
        );
      },
    );
  }
}

class NewsCardWidget extends StatelessWidget {
  NewsCard card;
  NewsCardWidget({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 90,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Text(card.imgURL),
          SizedBox(width: 10),
          Text(card.title),
        ],
      ),
    );
  }
}
