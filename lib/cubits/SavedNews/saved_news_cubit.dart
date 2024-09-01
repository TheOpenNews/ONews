import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:onews/consts/LocalStorage.dart';

part 'saved_news_state.dart';

class SavedNewsCubit extends Cubit<SavedNewsState> {
  SavedNewsCubit() : super(SavedNewsState(savedNewsIds: Set<String>())) {
    LocalStorage.loadSavedNews().then((value) {
      Set<String> savedNewsIds = Set<String>();
      for(String key in value.keys) {
        savedNewsIds.add(key);
      } 
      emit(state.copyWith(savedNewsIds: savedNewsIds));
    });
  }

  toggleSavedNews(String uuid) {
    if (state.savedNewsIds.contains(uuid)) {
      state.savedNewsIds.remove(uuid);
    } else {
      state.savedNewsIds.add(uuid);
    }
    debugPrint(state.savedNewsIds.toString());
    emit(state.copyWith(savedNewsIds: state.savedNewsIds));
  }
}
