import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/NativeInterface.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:onews/modules/LocalExtensionInfo.dart';
import 'package:onews/repos/ExtensionsRepo.dart';
import 'package:onews/repos/LocalExtensionsRepo.dart';

part 'extension_manager_event.dart';
part 'extension_manager_state.dart';

class ExtensionManagerBloc extends Bloc<ExtensionManagerEvent,ExtensionManagerState> {
  final ExtensionsRepo _extensionsRepo;
  final LocalExtensionsRepo _localExtensionsRepo;
  ExtensionManagerBloc(this._extensionsRepo,this._localExtensionsRepo) : super(ExtensionManagerState()) {
    on<QueryExtensionsInfo>(onQueryExtensionsInfo);
    on<LoadLocalExtension>(onLoadLocalExtension);
  }

  void onQueryExtensionsInfo(event, emit) async {
    emit(state.copyWith(loadState: ExtensionsLoadState.Loading));
    try {
      var onlineExtensions = await _extensionsRepo.queryExtensionInfo();
      emit(
        state.copyWith(
          extensionInfo: onlineExtensions,
          loadState: ExtensionsLoadState.None,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadState: ExtensionsLoadState.Error));
      return;
    }
  }

  void onLoadLocalExtension(LoadLocalExtension event, emit) async {
    emit(state.copyWith(libaryLoadState: ExtensionsLoadState.Loading));
    var data = await NativeInterface.loadLocalExtensions();
    _localExtensionsRepo.loadLocalExtensions(data!);
    emit(
      state.copyWith(
        localExtensions: _localExtensionsRepo.localExtensions,
        libaryLoadState: ExtensionsLoadState.None,
      ),
    );
  }
}
