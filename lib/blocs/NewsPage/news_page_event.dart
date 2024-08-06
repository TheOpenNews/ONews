part of 'news_page_bloc.dart';

sealed class NewsPageEvent extends Equatable {
  const NewsPageEvent();
  @override
  List<Object> get props => [];
}

class ShowNewsPage extends NewsPageEvent {
  NewsCard card;
  ShowNewsPage(this.card);

  @override
  List<Object> get props => [
        card,
      ];
}


class LoadNewsPage extends NewsPageEvent {
}
