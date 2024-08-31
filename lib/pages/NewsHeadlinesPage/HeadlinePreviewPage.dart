import 'package:cached_network_image/cached_network_image.dart';
import 'package:onews/blocs/HeadlinesPage/headlines_page_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/modules/HeadlineCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/pages/NewsHeadlinesPage/widgets/CategoryFilterWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/widgets/HeadlineCardLoadingWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/widgets/HeadlineCardWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/widgets/HomeHeadlinesLoadingWidget.dart';
import 'package:onews/pages/NewsHeadlinesPage/widgets/HomeHeadlinesWidget.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class HeadlinePreviewPage extends StatefulWidget {
  const HeadlinePreviewPage({super.key});

  @override
  State<HeadlinePreviewPage> createState() => _HeadlinePreviewPageState();
}

class _HeadlinePreviewPageState extends State<HeadlinePreviewPage> {
  late ScrollController scrollController;
  bool stopLoadingNews = false;
  bool networkError = false;
  late List<String> tags = [];

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        if (stopLoadingNews) return;
        if (networkError) return;
        // context.read<HeadlinesPageBloc>().add(NextPage());
      }
    });
    context.read<HeadlinesPageBloc>().add(LoadHomePageHeadlines());
    context.read<HeadlinesPageBloc>().add(NextPage());
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onSelectCategory(tag) {
    context.read<HeadlinesPageBloc>().add(ChangeCategory(tag));
  }

  void _onTryAgain() {
    networkError = false;
    context.read<HeadlinesPageBloc>().add(
          context.read<HeadlinesPageBloc>().state.latestEvent,
        );
  }

  void _errorTypeSnackbar(HeadlinesPageState state) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar_widget(context.read<HeadlinesPageBloc>().state, context),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        clipBehavior: Clip.none,
        child: BlocConsumer<HeadlinesPageBloc, HeadlinesPageState>(
          listener: (context, state) {
            _errorTypeSnackbar(state);
          },
          builder: (context, state) {
            // if (state.errorType != HeadlinesErrorType.None &&
            //     state.errorType != HeadlinesErrorType.NoHeadlines) {
            //   return _error_widget();
            // }

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
                  // _load_more_news_widget(state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _load_more_news_widget(HeadlinesPageState state) {
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

  Widget _home_headlines_widget(BuildContext context, HeadlinesPageState state) {
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
                return HomeHeadlinesLoadingWidget();
              } else {
                return HomeHeadlinesWidget(
                    headline: state.homePageHeadlines[idx]);
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
      clipBehavior: Clip.none,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: CategoryFilterWidget(
        tags: categories,
        onSelectCategory: _onSelectCategory,
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

  AppBar _appbar_widget(HeadlinesPageState state, context) {
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

  Widget _headlines_widget(HeadlinesPageState state) {
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
    if (state.newsCards.length == 0) {
      return Column(
        children: [
          SizedBox(height: 64),
          Text(
            "Encounted a problem loading news headlines",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontVariations: [FontVariation("wght", 500)],
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<HeadlinesPageBloc>().add(state.latestEvent);
            },
            child: Text(
              "Retry",
              style: TextStyle(
                fontSize: 18,
                color: CColors.primaryBlue,
                fontVariations: [FontVariation("wght", 600)],
              ),
            ),
          )
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
