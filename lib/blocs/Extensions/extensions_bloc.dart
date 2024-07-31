import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:muslimnews/repos/ExtensionsRepo.dart';

part 'extensions_event.dart';
part 'extensions_state.dart';

class ExtensionsBloc extends Bloc<ExtensionsEvent, ExtensionsState> {
  ExtensionsRepo _extensionsRepo;
  ExtensionsBloc(this._extensionsRepo) : super(ExtensionsState()) {
    on<LoadExtensionsInfo>(onLoadExtensionsInfo);
  }

  void onLoadExtensionsInfo(event, emit) async {
    emit(state.copyWith(loadState: ExtensionsLoadState.Loading));

    try {
      await _extensionsRepo.loadExtensionInfoList();
      emit(state.copyWith(loadState: ExtensionsLoadState.None));
    } catch (e) {
      emit(state.copyWith(loadState: ExtensionsLoadState.None));
    }
  }
}
