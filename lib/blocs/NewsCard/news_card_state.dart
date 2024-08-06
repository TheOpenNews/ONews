part of 'news_card_bloc.dart';

enum NewsCardsLoadingStatus { Loading, None }

class NewsCardState extends Equatable {
  ExtensionInfo extensionInfo;
  List<NewsCard> newsCards;
  NewsCardsLoadingStatus loadingStatus;
  int page = 1;
  bool newsDone = false;
  String category;

  NewsCardState({
    required this.extensionInfo,
    this.newsCards = const [],
    this.page = 1,
    this.loadingStatus = NewsCardsLoadingStatus.None,
    this.newsDone = false,
    this.category = "Politics",
  });

  NewsCardState copyWith({
    ExtensionInfo? extensionInfo,
    List<NewsCard>? newsCards,
    int? page,
    NewsCardsLoadingStatus? loadingStatus,
    bool? newsDone,
    String? category,
  }) =>
      NewsCardState(
        extensionInfo: extensionInfo ?? this.extensionInfo,
        newsCards: newsCards ?? this.newsCards,
        page: page ?? this.page,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        newsDone: newsDone ?? this.newsDone,
        category: category ?? this.category,
      );

  @override
  List<Object> get props =>
      [extensionInfo, newsCards, page, loadingStatus, newsDone, category];
}
