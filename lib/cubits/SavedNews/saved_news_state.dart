part of 'saved_news_cubit.dart';

class SavedNewsState extends Equatable {
  Set<String> savedNewsIds;
  SavedNewsState({required this.savedNewsIds });

  SavedNewsState copyWith({
    Set<String>? savedNewsIds,
  }) =>
      SavedNewsState(
        savedNewsIds: savedNewsIds ?? this.savedNewsIds,
      );

  @override
  List<Object> get props => [savedNewsIds];
}
