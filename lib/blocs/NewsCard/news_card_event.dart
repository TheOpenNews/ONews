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
