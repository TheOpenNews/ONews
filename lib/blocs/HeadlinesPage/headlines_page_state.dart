

part of 'headlines_page_bloc.dart';

enum NewsCardsLoadingStatus { Loading, None, Failed }
enum HomePageHeadlinesState {None , Loading}
enum HeadlinesErrorType { Network, NoHeadlines, Extension, None }

class HeadlinesPageState extends Equatable {
  LocalExtensionInfo extensionInfo;
  List<HeadlineCard> newsCards;
  List<HeadlineCard> homePageHeadlines;
  NewsCardsLoadingStatus loadingStatus;
  int page = 1;
  bool newsDone = false;
  String category;
  HeadlinesPageEvent latestEvent = SelectPage();

  String errorMsg;
  HeadlinesErrorType errorType;
  HeadlineCard selectedCard;


  HomePageHeadlinesState homePageHeadlinesState;
  
  HeadlinesPageState({
    required this.extensionInfo,
    required HeadlinesPageEvent latestEvent,
    required this.selectedCard,
    this.newsCards = const [],
    this.homePageHeadlines = const [],
    this.page = 1,
    this.loadingStatus = NewsCardsLoadingStatus.None,
    this.newsDone = false,
    this.category = "Politics",
    this.errorType = HeadlinesErrorType.None,
    this.errorMsg = "",
    this.homePageHeadlinesState = HomePageHeadlinesState.None,
  });

  HeadlinesPageState copyWith({
    LocalExtensionInfo? extensionInfo,
    List<HeadlineCard>? newsCards,
    List<HeadlineCard>? homePageHeadlines,
    int? page,
    NewsCardsLoadingStatus? loadingStatus,
    bool? newsDone,
    String? category,
    HeadlinesPageEvent? latestEvent,
    String? errorType,
    String? errorMsg,
    HomePageHeadlinesState? homePageHeadlinesState,
    HeadlineCard? selectedCard,
  }) {
    Map<String, HeadlinesErrorType> errorTypeMap = {
      "Network": HeadlinesErrorType.Network,
      "NoHeadlines": HeadlinesErrorType.NoHeadlines,
      "Extension": HeadlinesErrorType.Extension,
      "None": HeadlinesErrorType.None,
    };



    return HeadlinesPageState(
      extensionInfo: extensionInfo ?? this.extensionInfo,
      newsCards: newsCards ?? this.newsCards,
      page: page ?? this.page,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      newsDone: newsDone ?? this.newsDone,
      category: category ?? this.category,
      latestEvent: latestEvent ?? this.latestEvent,
      errorType: errorTypeMap[errorType] ?? HeadlinesErrorType.None,
      errorMsg: errorMsg ?? "",
      homePageHeadlines: homePageHeadlines ?? this.homePageHeadlines,
      homePageHeadlinesState: homePageHeadlinesState ?? this.homePageHeadlinesState,
      selectedCard: selectedCard ?? this.selectedCard,
      
    );
  }

  @override
  List<Object> get props => [
        extensionInfo,
        newsCards,
        page,
        loadingStatus,
        newsDone,
        category,
        latestEvent,
        homePageHeadlines,
        errorMsg,
        errorType,
        homePageHeadlinesState,
selectedCard,
      ];
}
