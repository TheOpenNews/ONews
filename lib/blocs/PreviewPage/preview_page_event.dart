part of 'preview_page_bloc.dart';

sealed class NewsPageEvent extends Equatable {
  const NewsPageEvent();
  @override
  List<Object> get props => [];
}

class ShowNewsPage extends NewsPageEvent {
  HeadlineCard card;
  ExtensionInfo info;
  ShowNewsPage(this.card,this.info);

  @override
  List<Object> get props => [
        card,
        info
      ];
}

class LoadNewsPage extends NewsPageEvent {}
