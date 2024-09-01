import 'package:onews/Ui/CustomAppBarWidget.dart';
import 'package:onews/blocs/PreviewPage/preview_page_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/consts/LocalStorage.dart';
import 'package:onews/cubits/SavedNews/saved_news_cubit.dart';
import 'package:onews/pages/NewsPreviewPage/widgets/PageBodyWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/repos/SavedNewsRepo.dart';

class NewsPreviewPage extends StatefulWidget {
  const NewsPreviewPage({super.key});

  @override
  State<NewsPreviewPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPreviewPage> {
  bool isSaved = false;

  @override
  void initState() {
    isSaved = false;
    super.initState();
    context.read<NewsPageBloc>().add(LoadNewsPage());

  }

  void onTryAgain() {
    context.read<NewsPageBloc>().add(LoadNewsPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedNewsCubit, SavedNewsState>(
      builder: (context, savedNewsState) {
        return BlocConsumer<NewsPageBloc, NewsPageState>(
          listener: (context, state) {
            String Uuid = LocalStorage.UuidFromString(state.news.title);
            if (isSaved != savedNewsState.savedNewsIds.contains(Uuid)) {
              setState(() {
                isSaved = !isSaved;
              });
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBarWidget(
                actions: [
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        isSaved = !isSaved;
                      });
                      await state.news.saveToLocalStroage();
                      context.read<SavedNewsCubit>().toggleSavedNews(LocalStorage.UuidFromString(state.news.title));

                    },
                    icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  ),
                ],
              ),
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
      },
    );
  }
}
