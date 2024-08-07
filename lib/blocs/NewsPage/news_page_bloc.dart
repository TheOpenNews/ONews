import 'package:anynews/NativeInterface.dart';
import 'package:anynews/blocs/NewsCard/news_card_bloc.dart';
import 'package:anynews/modules/News.dart';
import 'package:anynews/modules/NewsCard.dart';
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
    emit(state.copyWith(card: event.card));
  }

  void onLoadNewsPage(event,emit) async {
    emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.Loading));
    News? news =  await NativeInterface.scrapeUrl(state.card.link);
    if(news == null) {
      emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.Failed));
      return;
    }
    emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.None, news : news));
  }
}


