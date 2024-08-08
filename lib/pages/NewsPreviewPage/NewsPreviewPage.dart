import 'package:onews/blocs/NewsPage/news_page_bloc.dart';
import 'package:onews/modules/News.dart';
import 'package:onews/pages/NewsPreviewPage/ImageElemWidget.dart';
import 'package:onews/pages/NewsPreviewPage/PageBodyWidget.dart';
import 'package:onews/pages/NewsPreviewPage/TextElemWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPreviewPage extends StatefulWidget {
  const NewsPreviewPage({super.key});

  @override
  State<NewsPreviewPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPreviewPage> {
  @override
  void initState() {
    context.read<NewsPageBloc>().add(LoadNewsPage());
    super.initState();
  }

  void onTryAgain() {
    context.read<NewsPageBloc>().add(LoadNewsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsPageBloc, NewsPageState>(
      listener: (context, state) {
        if (state.loadingStatus == PageNewsLoadingStatus.Failed) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to load page, check your interent connection",
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(state),
          body: Container(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: state.loadingStatus == PageNewsLoadingStatus.Loading
                ? Center(child: CircularProgressIndicator())
                : state.loadingStatus == PageNewsLoadingStatus.Failed
                    ? Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: onTryAgain,
                        child: Text("Try Again"),
                      ),
                    )
                    : SingleChildScrollView(
                        child: PageBodyWidget(
                          news: state.news,
                        ),
                      ),
          ),
        );
      },
    );
  }

  AppBar _appbar(NewsPageState state) {
    return AppBar(
      title: Text(
        "NewsPreviewPage",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF13a2cc),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      actions: [
        IconButton(
          onPressed: () => launchUrl(Uri.parse(state.card.link)),
          icon: Icon(Icons.preview),
        ),
      ],
    );
  }
}
