import 'package:onews/ApkManager.dart';
import 'package:onews/consts/Paths.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'extension_download_event.dart';
part 'extension_download_state.dart';

class ExtensionDownloadBloc
    extends Bloc<ExtensionDownloadEvent, ExtensionDownloadState> {
  ExtensionDownloadBloc() : super(ExtensionDownloadState()) {
    on<CompeletedTheExtensionDownload>(onCompeletedTheExtensionDownload);
    on<FailedTheExtensionDownload>(onFailedTheExtensionDownload);
    on<DownloadExtensionApk>(onDownloadExtensionApk);
  }

  void onDownloadExtensionApk(DownloadExtensionApk event, emit) async {
    await ApkManager.downloadApk(event.apkName, event.apkURL);
    emit(
      state.copyWith(
        downloadStatus: ExtensionDownloadStatus.None,
        apkName: event.apkName,
      ),
    );
  }

  void onCompeletedTheExtensionDownload(event, emit) async {
    emit(state.copyWith(downloadStatus: ExtensionDownloadStatus.Completed));
    await ApkManager.installApk(state.apkName);
    emit(state.copyWith(downloadStatus: ExtensionDownloadStatus.None));
  }

  void onFailedTheExtensionDownload(event, emit) async {
    emit(state.copyWith(downloadStatus: ExtensionDownloadStatus.Failed));
  }
}
