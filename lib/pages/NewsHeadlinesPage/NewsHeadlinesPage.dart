import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:onews/NativeInterface.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/modules/NewsCard.dart';
import 'package:onews/pages/NewsHeadlinesPage/CategoryFilterWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/HeadlineCardLoadingWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/HeadlineCardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/pages/ui/LoadingLineWidget.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class NewsHeadlinesPage extends StatefulWidget {
  const NewsHeadlinesPage({super.key});

  @override
  State<NewsHeadlinesPage> createState() => _NewsHeadlinesPageState();
}

class _NewsHeadlinesPageState extends State<NewsHeadlinesPage> {
  late ScrollController scrollController;
  bool stopLoadingNews = false;
  bool networkError = false;
  late List<String> tags = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (stopLoadingNews) return;
        if (networkError) return;
        // context.read<NewsCardBloc>().add(NextPage());
      }
    });
    context.read<NewsCardBloc>().add(LoadHomePageHeadlines());
    context.read<NewsCardBloc>().add(NextPage());
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onSelectCategory(tag) {
    context.read<NewsCardBloc>().add(ChangeCategory(tag));
    context.read<NewsCardBloc>().add(SelectPage(1));
  }

  void onTryAgain() {
    networkError = false;
    context
        .read<NewsCardBloc>()
        .add(context.read<NewsCardBloc>().state.latestEvent);
  }

  void errorTypeSnackbar(NewsCardState state) {
    if (state.errorType == HeadlinesErrorType.None ||
        state.errorType == HeadlinesErrorType.NoHeadlines) {
      return;
    }
    String msg = "";
    switch (state.errorType) {
      case HeadlinesErrorType.Extension:
      // msg = "The Extension Encountered a problem, please report it";
      // break;
      case HeadlinesErrorType.Network:
        msg = "Encountered a Network problem, check your network connection";
        break;
      default:
        return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontSize: 18,
            fontVariations: [FontVariation("wght", 500)],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar_widget(context.read<NewsCardBloc>().state, context),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: BlocConsumer<NewsCardBloc, NewsCardState>(
          listener: (context, state) {
            errorTypeSnackbar(state);
          },
          builder: (context, state) {
            if (state.errorType != HeadlinesErrorType.None &&
                state.errorType != HeadlinesErrorType.NoHeadlines) {
              return _error_widget();
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _home_headlines_widget(context, state),
                  SizedBox(height: 32),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Headlines:",
                      style: TextStyle(
                          fontSize: 22,
                          fontVariations: [FontVariation("wght", 700)]),
                    ),
                  ),
                  SizedBox(height: 10),
                  _searchbar_widget(),
                  _category_widget(state.extensionInfo.categories),
                  _headlines_widget(state),
                  _load_more_news_widget(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _load_more_news_widget(NewsCardState state) {
    if (state.loadingStatus == NewsCardsLoadingStatus.Loading) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            size: 32,
            color: CColors.primaryBlue,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _home_headlines_widget(BuildContext context, NewsCardState state) {
    if (state.homePageHeadlines.length == 0 &&
        state.homePageHeadlinesState == HomePageHeadlinesState.None) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(height: 24),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Home:",
            style: TextStyle(
              fontSize: 22,
              fontVariations: [FontVariation("wght", 700)],
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 220,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.none,
          child: ScrollSnapList(
            itemCount:
                state.homePageHeadlinesState == HomePageHeadlinesState.Loading
                    ? 1
                    : state.homePageHeadlines.length,
            itemSize: 320,
            clipBehavior: Clip.none,
            onItemFocus: (idx) {},
            dynamicItemSize: true,
            itemBuilder: (ctx, idx) {
              if (state.homePageHeadlinesState ==
                  HomePageHeadlinesState.Loading) {
                return HomePageHeadlinesLoadingWidget();
              } else {
                return HomePageHeadlines(
                  headline: state.homePageHeadlines[idx],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Column _error_widget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Failed to load headlines, please check your interent connection",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontVariations: [FontVariation("wght", 600)],
          ),
        ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {},
          child: Text(
            "Try Again",
            style: TextStyle(
              fontSize: 20,
              color: CColors.primaryBlue,
              fontVariations: [FontVariation("wght", 600)],
            ),
          ),
        ),
      ],
    );
  }

  Container _category_widget(categories) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: CategoryFilterWidget(
        tags: categories,
        onSelectCategory: onSelectCategory,
      ),
    );
  }

  Widget _searchbar_widget() {
    var fborder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: CColors.primaryBlue, width: 2),
    );
    var eborder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.2),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(
          fontVariations: [FontVariation("wght", 600)],
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          prefixIcon: Icon(Icons.search, color: Colors.black.withOpacity(0.6)),
          hintText: "Search",
          enabledBorder: eborder,
          focusedBorder: fborder,
        ),
      ),
    );
  }

  AppBar _appbar_widget(NewsCardState state, context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black.withOpacity(0.5)),
      title: Row(
        children: [
          Text(
            state.extensionInfo.name,
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

  Widget _headlines_widget(NewsCardState state) {
    if (state.loadingStatus == NewsCardsLoadingStatus.Loading) {
      return Column(
        children: [
          for (int i = 0; i < 4; i++) ...[
            HeadlineCardLoadingWidget(),
            SizedBox(height: 8)
          ],
        ],
      );
    }
    return Column(
      children: [
        ...state.newsCards.map(
          (card) => HeadlineCardWidget(
            card: card,
          ),
        )
      ],
    );
  }
}

class HomePageHeadlines extends StatelessWidget {
  HomePageHeadlines({
    super.key,
    required this.headline,
  });
  NewsCard headline;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: Container(
                  width: 320,
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        headline.imgURL,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 320,
                  height: 220,
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
              Positioned(
                child: Container(
                  width: 320,
                  height: 220,
                  padding: EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: headline.date + "\n",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontVariations: [FontVariation("wght", 600)])),
                      TextSpan(
                        text: headline.title.length > 60
                            ? headline.title.substring(0, 60) + "..."
                            : headline.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontVariations: [FontVariation("wght", 700)],
                        ),
                      ),
                    ])),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePageHeadlinesLoadingWidget extends StatelessWidget {
  HomePageHeadlinesLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 200,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.4),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: LoadingLineWidget(
                width: 80,
                color: Colors.grey[350]!,
              ),
            ),
            SizedBox(height: 10),
            LoadingLineWidget(
              width: double.infinity,
              color: Colors.grey[350]!,
            ),
            SizedBox(height: 10),
            LoadingLineWidget(
              width: double.infinity,
              color: Colors.grey[350]!,
            ),
            SizedBox(height: 10),
            LoadingLineWidget(
              width: double.infinity,
              color: Colors.grey[350]!,
            ),
          ],
        ),
      ),
    );
  }
}
