import 'package:anynews/NativeInterface.dart';
import 'package:anynews/blocs/NewsCard/news_card_bloc.dart';
import 'package:anynews/modules/NewsCard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'news_page_event.dart';
part 'news_page_state.dart';

class NewsPageBloc extends Bloc<NewsPageEvent, NewsPageState> {
  NewsPageBloc() : super(NewsPageState(card: NewsCard("","","",""))) {
    on<ShowNewsPage>(onShowNewsPage);
    on<LoadNewsPage>(onLoadNewsPage);
    
  }


  void onShowNewsPage(ShowNewsPage event , emit) {
    emit(state.copyWith(card: event.card));
  }

  void onLoadNewsPage(event,emit) async {
    emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.Loading));
    await NativeInterface.scrapeUrl(state.card.link);
    emit(state.copyWith(loadingStatus: PageNewsLoadingStatus.None));
  }
}


