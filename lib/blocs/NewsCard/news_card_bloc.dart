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
      : super(NewsCardState(extensionInfo: ExtensionInfo("", "", "", ""))) {
    on<SelectExtension>(onSelectExtension);
    on<NextPage>(onNextPage);
  }

  void onSelectExtension(SelectExtension event, emit) async {
    emit(state.copyWith(extensionInfo: event.info));
    List<NewsCard> cards = await NativeInterface.loadNewsHeadlines(event.info);
    emit(state.copyWith(newsCards: cards));
  }

  void onNextPage(NextPage event, emit) async {
    debugPrint(state.loadingStatus.toString());
    if (state.loadingStatus == NewsCardsLoadingStatus.Loading) return;
    emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Loading));

    debugPrint((state.page + 1).toString());
    List<NewsCard> cards = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: state.page + 1,
    );

    emit(state.copyWith(
      page: state.page + 1,
      newsCards: state.newsCards = [...state.newsCards, ...cards],
      loadingStatus: NewsCardsLoadingStatus.None,
    ));
  }
}
