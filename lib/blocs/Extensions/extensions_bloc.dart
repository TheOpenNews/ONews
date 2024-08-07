import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:anynews/ApkManager.dart';
import 'package:anynews/modules/ExtensionInfo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:meta/meta.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';
import 'package:path_provider/path_provider.dart';

part 'extensions_event.dart';
part 'extensions_state.dart';

class ExtensionsBloc extends Bloc<ExtensionsEvent, ExtensionsState> {
  ExtensionsRepo _extensionsRepo;

  ExtensionsBloc(this._extensionsRepo) : super(ExtensionsState()) {
    on<LoadExtensionsInfo>(onLoadExtensionsInfo);
    on<LoadLocalExtension>(onLoadLocalExtension);
    
  }

  void onLoadExtensionsInfo(event, emit) async {
      _extensionsRepo.extensionsInfoList = [];
    emit(state.copyWith(loadState: ExtensionsLoadState.Loading));
    try {
      await _extensionsRepo.loadExtensionInfoList();
    } catch (e) {
    }
    emit(state.copyWith(loadState: ExtensionsLoadState.None));
  }


  void onLoadLocalExtension(LoadLocalExtension event, emit) {
    emit(state.copyWith(localExtensions: event.localExtensions));
  }
 

}
