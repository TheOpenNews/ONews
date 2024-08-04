import 'dart:io';

import 'package:android_package_installer/android_package_installer.dart';
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
    on<DownloadExtensionApk>(onDownloadExtensionApk);
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


  void onDownloadExtensionApk(DownloadExtensionApk event, emit) async {
    debugPrint("+++++++++++++++AA+++++++++");
    debugPrint((await getDownloadsDirectory())!.path);
    debugPrint(
      (await File("/storage/emulated/0/Download" + "/s2jnews-debug.apk").exists()).toString()
      );
         debugPrint(
        Directory("/storage/emulated/0/Download/").listSync().toString()
      );


      var out = await AndroidPackageInstaller.installApk(apkFilePath: "/storage/emulated/0/Download" + "/s2jnews-debug.apk");
      debugPrint(out.toString());
      debugPrint(PackageInstallerStatus.byCode(out!).toString());


    // var taskID =  await FlutterDownloader.enqueue(
    //   url: event.apkURL,
    //   headers: {},
    //   savedDir:  "/storage/emulated/0/Download",
    //   showNotification: true,
    //   saveInPublicStorage: true,
    // );
  }
}
