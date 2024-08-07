import 'dart:ffi';

import 'package:anynews/NativeInterface.dart';
import 'package:anynews/modules/ExtensionInfo.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'news_card_event.dart';
part 'news_card_state.dart';

class NewsCardBloc extends Bloc<NewsCardEvent, NewsCardState> {
  NewsCardBloc()
      : super(NewsCardState(extensionInfo: ExtensionInfo("", "", "", "", ""),latestEvent: SelectPage(1),)) {
    on<SelectExtension>(onSelectExtension);
    on<NextPage>(onNextPage);
    on<ChangeCategory>(onChangeCategory);
    on<SelectPage>(onSelectPage);
  }

  void onSelectExtension(SelectExtension event, emit) async {
    emit(state.copyWith(
        extensionInfo: event.info,
        loadingStatus: NewsCardsLoadingStatus.Loading));
    List<NewsCard>? cards = await NativeInterface.loadNewsHeadlines(event.info);

    if (cards == null) {
      emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Failed));
      return;
    }
    emit(state.copyWith(
        newsCards: cards, loadingStatus: NewsCardsLoadingStatus.None));
  }

  void onNextPage(NextPage event, emit) async {
    emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Loading));
    List<NewsCard>? cards = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: state.page + 1,
      category: state.category,
    );
    if (cards == null) {
      emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Failed, latestEvent: event));
      return;
    }

    // news done
    if (cards.length == 0) {
      emit(state.copyWith(newsDone: true));
    } else {
      emit(state.copyWith(
        page: state.page + 1,
        newsCards: state.newsCards = [...state.newsCards, ...cards],
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
    emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Loading));
    List<NewsCard>? cards = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: event.page,
      category: state.category,
    );
    if (cards == null) {
      emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Failed , latestEvent:  event));
      return;
    }

    // news done
    if (cards.length == 0) {
      emit(state.copyWith(newsDone: true));
    } else {
      emit(state.copyWith(
        page: event.page,
        newsCards: state.newsCards = [...state.newsCards, ...cards],
        loadingStatus: NewsCardsLoadingStatus.None,
      ));
    }
  }
}
