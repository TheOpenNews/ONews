part of 'news_page_bloc.dart';

enum PageNewsLoadingStatus { Loading, None }

class NewsPageState extends Equatable {
  NewsCard card;
  PageNewsLoadingStatus loadingStatus;
  News news;

  NewsPageState({
    required this.card,
    required this.news,
    this.loadingStatus = PageNewsLoadingStatus.Loading,

  });

  NewsPageState copyWith({
    NewsCard? card,
    PageNewsLoadingStatus? loadingStatus,
    News? news,
  }) =>
      NewsPageState(
        card: card ?? this.card,
        news: news ?? this.news,
        loadingStatus: loadingStatus ?? this.loadingStatus,
      );

  @override
  List<Object> get props => [
        card,
        news,
        loadingStatus,
      ];
}
