import 'package:anynews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:anynews/blocs/NewsCard/news_card_bloc.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:anynews/pages/NewsHeadlinesPage/CategoryFilterWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsHeadlinesPage extends StatefulWidget {
  const NewsHeadlinesPage({super.key});

  @override
  State<NewsHeadlinesPage> createState() => _NewsHeadlinesPageState();
}

class _NewsHeadlinesPageState extends State<NewsHeadlinesPage> {
  late ScrollController scrollController;
  bool stopLoadingNews = false;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (stopLoadingNews) return;
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

  List<String> tags = [
    "Politics",
    "Sport",
    "General",
  ];

  void onSelectCategory(tag) {
    context.read<NewsCardBloc>().add(ChangeCategory(tag));
    context.read<NewsCardBloc>().add(SelectPage(1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCardBloc, NewsCardState>(
      listener: (context, state) {
        if(state.newsDone != stopLoadingNews) {
            setState(() {
              stopLoadingNews = state.newsDone;
            });

        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(state, context),
          backgroundColor: Color(0xFFf4f4f6),
          body: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  child: CategoryFilterWidget(
                    tags: tags,
                    onSelectCategory: onSelectCategory,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      if (index < state.newsCards.length) {
                        return HeadlineCardWidget(
                          card: state.newsCards[index],
                        );
                      } else {
                        Widget widget = CircularProgressIndicator();
                        if (state.newsDone) {
                          widget = Text(
                            ". . .",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          );
                        }
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 8, bottom: 8),
                          child: widget,
                        );
                      }
                    },
                    itemCount: state.newsCards.length + 1,
                  ),
                ),
              ],
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
        onPressed: () => context.read<BottomNavBarCubit>().setIdx(1),
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
