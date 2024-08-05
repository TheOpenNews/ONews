import 'package:anynews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:anynews/blocs/NewsCard/news_card_bloc.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsHeadlinesPage extends StatefulWidget {
  const NewsHeadlinesPage({super.key});

  @override
  State<NewsHeadlinesPage> createState() => _NewsHeadlinesPageState();
}

class _NewsHeadlinesPageState extends State<NewsHeadlinesPage> {
  late ScrollController scrollController;
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if(scrollController.offset == scrollController.position.maxScrollExtent) {
          
          context.read<NewsCardBloc>().add(NextPage());
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCardBloc, NewsCardState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(state, context),
          backgroundColor: Color(0xFFf4f4f6),
          body: Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 8),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index < state.newsCards.length) {
                  return HeadlineCardWidget(
                    card: state.newsCards[index],
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 8,bottom: 8),
                    child: CircularProgressIndicator(),
                  );
                }
              },
              itemCount: state.newsCards.length + 1,
            ),
          ),
        );
      },
    );
  }

  AppBar _appbar(NewsCardState state, BuildContext context) {
    return AppBar(
      title: Text(
        state.extensionInfo.name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF13a2cc),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.read<BottomNavBarCubit>().setIdx(0),
      ),
    );
  }
}

class HeadlineCardWidget extends StatelessWidget {
  NewsCard card;
  HeadlineCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.1),
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              card.date,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              card.title,
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 16),
          Image.network(
            card.imgURL,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
