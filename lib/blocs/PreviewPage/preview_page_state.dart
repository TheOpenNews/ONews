part of 'preview_page_bloc.dart';

enum PageNewsLoadingStatus { Loading, None , Failed }

class NewsPageState extends Equatable {
  HeadlineCard card;
  PageNewsLoadingStatus loadingStatus;
  PreviewNewsData news;
  LocalExtensionInfo? extInfo;

  NewsPageState({
    required this.card,
    required this.news,
    this.extInfo = null,
    this.loadingStatus = PageNewsLoadingStatus.Loading,

  });

  NewsPageState copyWith({
    HeadlineCard? card,
    PageNewsLoadingStatus? loadingStatus,
    PreviewNewsData? news,
    LocalExtensionInfo?  extInfo,
  }) =>
      NewsPageState(
        card: card ?? this.card,
        news: news ?? this.news,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        extInfo: extInfo ?? this.extInfo,
      );


  

  @override
  List<Object> get props => [
        card,
        news,
        loadingStatus,
      ];
}
