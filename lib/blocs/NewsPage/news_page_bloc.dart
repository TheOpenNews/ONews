import 'package:onews/NativeInterface.dart';
import 'package:onews/blocs/NewsCard/news_card_bloc.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/News.dart';
import 'package:onews/modules/NewsCard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'news_page_event.dart';
part 'news_page_state.dart';

class NewsPageBloc extends Bloc<NewsPageEvent, NewsPageState> {
  NewsPageBloc() : super(NewsPageState(card: NewsCard("","","",""),news: News(content: []))) {
    on<ShowNewsPage>(onShowNewsPage);
    on<LoadNewsPage>(onLoadNewsPage);
    
  }


  void onShowNewsPage(ShowNewsPage event , emit) {
    emit(state.copyWith(extInfo: event.info,card: event.card));
  }

  void onLoadNewsPage(LoadNewsPage event,emit) async {
    emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.Loading));
    News? news =  await NativeInterface.scrapeUrl(state.extInfo!,state.card.link);
    if(news == null) {
      emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.Failed));
      return;
    }
    emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.None, news : news));
  }
}


