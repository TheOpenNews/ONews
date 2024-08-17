part of 'news_card_bloc.dart';

sealed class NewsCardEvent extends Equatable {
  const NewsCardEvent();

  @override
  List<Object> get props => [];
}


class SelectExtension extends NewsCardEvent {
  ExtensionInfo info;
  SelectExtension(this.info);
}
class NextPage extends NewsCardEvent {}
class SelectPage extends NewsCardEvent {
  int page;
  SelectPage(this.page);
}
class ChangeCategory extends NewsCardEvent {
  String category;
  ChangeCategory(this.category);
}

class LoadHomePageHeadlines extends NewsCardEvent {
}
