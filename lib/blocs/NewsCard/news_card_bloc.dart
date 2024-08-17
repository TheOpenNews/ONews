import 'dart:ffi';

import 'package:onews/NativeInterface.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/NewsCard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'news_card_event.dart';
part 'news_card_state.dart';

List<NewsCard> parseJsonDataToHeadlines(List<Object?> data) {
  List<NewsCard> headlines = [];
  for (var i = 0; i < data.length; i++) {
    Map<String, String> cardData = Map();
    var card = data[i];
    (card as Map).forEach((key, value) {
      cardData[key] = value as String;
    });
    headlines.add(NewsCard.fromMap(cardData));
  }
  return headlines;
}

class NewsCardBloc extends Bloc<NewsCardEvent, NewsCardState> {
  NewsCardBloc()
      : super(NewsCardState(
          extensionInfo: ExtensionInfo("", "", "", "", ""),
          latestEvent: SelectPage(1),
        )) {
    on<SelectExtension>(onSelectExtension);
    on<NextPage>(onNextPage);
    on<ChangeCategory>(onChangeCategory);
    on<SelectPage>(onSelectPage);
    on<LoadHomePageHeadlines>(onLoadHomePageHeadlines);
  }

  void onSelectExtension(SelectExtension event, emit) async {
    emit(
      state.copyWith(
        extensionInfo: event.info,
        loadingStatus: NewsCardsLoadingStatus.Loading,
        homePageHeadlinesState: HomePageHeadlinesState.Loading,
        newsCards: [],
        homePageHeadlines: [],
      ),
    );

    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      event.info,
      category: event.info.categories[0],
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      debugPrint(data.toString());
      emit(
        state.copyWith(
          newsCards: parseJsonDataToHeadlines(data["data"]),
          loadingStatus: NewsCardsLoadingStatus.None,
        ),
      );
    }
  }

  void onNextPage(NextPage event, emit) async {
    emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Loading));
    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: state.page + 1,
      category: state.category,
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            latestEvent: event,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      emit(state.copyWith(
        page: state.page + 1,
        newsCards: state.newsCards = [
          ...state.newsCards,
          ...parseJsonDataToHeadlines(data["data"])
        ],
        loadingStatus: NewsCardsLoadingStatus.None,
      ));
    }
  }

  void onChangeCategory(ChangeCategory event, emit) async {
    emit(
      state.copyWith(
        newsDone: false,
        category: event.category,
        page: 1,
        newsCards: [],
        loadingStatus: NewsCardsLoadingStatus.None,
      ),
    );
  }

  void onSelectPage(SelectPage event, emit) async {
    emit(
      state.copyWith(
        loadingStatus: NewsCardsLoadingStatus.Loading,
        newsCards: [],
        homePageHeadlines: [],
      ),
    );
    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: event.page,
      category: state.category,
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            latestEvent: event,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      emit(state.copyWith(
        page: event.page,
        newsCards: state.newsCards = [
          ...state.newsCards,
          ...parseJsonDataToHeadlines(data["data"])
        ],
        loadingStatus: NewsCardsLoadingStatus.None,
      ));
    }
  }

  void onLoadHomePageHeadlines(event, emit) async {
    emit(
      state.copyWith(
        homePageHeadlinesState: HomePageHeadlinesState.Loading,
      ),
    );
    await Future.delayed(Duration(seconds: 4));
    Map<String, dynamic> data = await NativeInterface.scrapeHomePage(
      state.extensionInfo,
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (data["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            homePageHeadlinesState: HomePageHeadlinesState.Loading,
            newsDone: true,
            errorMsg: data["msg"],
            errorType: data["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            homePageHeadlinesState: HomePageHeadlinesState.Loading,
            latestEvent: event,
            errorMsg: data["msg"],
            errorType: data["type"],
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          homePageHeadlinesState: HomePageHeadlinesState.None,
          homePageHeadlines: parseJsonDataToHeadlines(data["data"]),
        ),
      );
    }
  }
}
