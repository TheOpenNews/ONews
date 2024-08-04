import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anynews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:anynews/widgets/BottomNavBarWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<NewsCard> cards = [NewsCard("Titlte", "URL")];
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
            child: Column(
              children: [NewsCardWidget(card: cards[0])],
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
          Text(card.imgUrl),
          SizedBox(width: 10),
          Text(card.title),
        ],
      ),
    );
  }
}
