part of 'headlines_page_bloc.dart';

sealed class HeadlinesPageEvent extends Equatable {
  const HeadlinesPageEvent();

  @override
  List<Object> get props => [];
}

class SelectExtension extends HeadlinesPageEvent {
  ExtensionInfo info;
  SelectExtension(this.info);
}

class NextPage extends HeadlinesPageEvent {}

class SelectPage extends HeadlinesPageEvent {
  int page;
  SelectPage({this.page = 1});
}

class ChangeCategory extends HeadlinesPageEvent {
  String category;
  ChangeCategory(this.category);
}

class LoadHomePageHeadlines extends HeadlinesPageEvent {}
