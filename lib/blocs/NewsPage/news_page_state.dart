part of 'news_page_bloc.dart';

enum PageNewsLoadingStatus { Loading, None }

class NewsPageState extends Equatable {
  NewsCard card;
  PageNewsLoadingStatus loadingStatus;

  NewsPageState({
    required this.card,
    this.loadingStatus = PageNewsLoadingStatus.Loading,
  });

  NewsPageState copyWith({
    NewsCard? card,
    PageNewsLoadingStatus? loadingStatus,
  }) =>
      NewsPageState(
        card: card ?? this.card,
        loadingStatus: loadingStatus ?? this.loadingStatus,
      );

  @override
  List<Object> get props => [
        card,
        loadingStatus,
      ];
}
