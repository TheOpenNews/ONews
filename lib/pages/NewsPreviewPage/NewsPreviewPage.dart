import 'package:onews/blocs/PreviewPage/preview_page_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/pages/NewsPreviewPage/widgets/PageBodyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar_widget(),
          body: state.loadingStatus == PageNewsLoadingStatus.Loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: CColors.primaryBlue,
                  ),
                )
              : state.loadingStatus == PageNewsLoadingStatus.Failed
                  ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Encounted a problem loading the page, if it persists please report it",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontVariations: [FontVariation("wght", 500)]),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: onTryAgain,
                            child: Text(
                              "Reload",
                              style: TextStyle(
                                  color: CColors.primaryBlue,
                                  fontSize: 20,
                                  fontVariations: [FontVariation("wght", 600)]),
                            ),
                          ),
                        ],
                      ),
                  )
                  : PageBodyWidget(
                      news: state.news,
                    ),
        );
      },
    );
  }

  AppBar _appbar_widget() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black.withOpacity(0.9)),
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
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_border)),
      ],
      elevation: 2,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.1),
    );
  }
}
