part of 'news_card_bloc.dart';

enum NewsCardsLoadingStatus { Loading, None }

class NewsCardState extends Equatable {
  ExtensionInfo extensionInfo;
  List<NewsCard> newsCards;
  int page = 1;
  NewsCardsLoadingStatus loadingStatus;

  NewsCardState({
    required this.extensionInfo,
    this.newsCards = const [],
    this.page = 1,
    this.loadingStatus = NewsCardsLoadingStatus.None,
  });

  NewsCardState copyWith({
    ExtensionInfo? extensionInfo,
    List<NewsCard>? newsCards,
    int? page,
    NewsCardsLoadingStatus? loadingStatus,
  }) =>
      NewsCardState(
        extensionInfo: extensionInfo ?? this.extensionInfo,
        newsCards: newsCards ?? this.newsCards,
        page: page ?? this.page,
        loadingStatus: loadingStatus ?? this.loadingStatus,

      );

  @override
  List<Object> get props => [extensionInfo, newsCards, page , loadingStatus];
}
