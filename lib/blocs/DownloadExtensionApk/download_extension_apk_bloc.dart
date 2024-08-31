
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/ApkManager.dart';
import 'package:equatable/equatable.dart';
import 'package:onews/modules/ExtensionInfo.dart';
part 'download_extension_apk_event.dart';
part 'download_extension_apk_state.dart';

class DownloadExtensionApkBloc
    extends Bloc<DownloadExtensionApkEvent, DownloadExtensionApkState> {
      DownloadExtensionApkBloc() : super(DownloadExtensionApkState()) {
    on<CompeletedDownloadingExtensionApk>(onCompeletedDownloadingExtensionApk);
    on<FailedDownloadingExtensionApk>(onFailedDownloadingExtensionApk);
    on<StartDownloadingExtensionApk>(onStartDownloadingExtensionApk);
  }

  void onStartDownloadingExtensionApk(StartDownloadingExtensionApk event, emit) async {
    await ApkManager.downloadApk(event.ext_info.apkName, event.apkURL);
    emit(
      state.copyWith(
        downloadStatus: ExtensionDownloadStatus.None,
        ext_info: event.ext_info,
      ),
    );
  }

  void onCompeletedDownloadingExtensionApk(event, emit) async {
    emit(state.copyWith(downloadStatus: ExtensionDownloadStatus.Completed));
  }

  void onFailedDownloadingExtensionApk(event, emit) async {
    emit(state.copyWith(downloadStatus: ExtensionDownloadStatus.Failed));
  }
}
