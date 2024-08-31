import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'download_extension_overlay_event.dart';
part 'download_extension_overlay_state.dart';

class DownloadExtensionOverlayBloc extends Bloc<DownloadExtensionOverlayEvent, DownloadExtensionOverlayState> {
  DownloadExtensionOverlayBloc() : super(DownloadExtensionOverlayState()) {
    on<ShowDownloadingOverlay>(onShowDownloadingOverlay);
    on<HideDownloadingOverlay>(onHideDownloadingOverlay);
    on<UpdateDownloadStatus>(onUpdateDownloadStatus);
  }

  void onShowDownloadingOverlay(ShowDownloadingOverlay event, emit) async { 
    emit(state.copyWith(status: 0,showOverlay: true));
  }

 void onHideDownloadingOverlay(HideDownloadingOverlay event, emit) async { 
    emit(state.copyWith(status: 0,showOverlay: false));
  }
  
  void onUpdateDownloadStatus(UpdateDownloadStatus event, emit) async { 
    emit(state.copyWith(status: event.status));
  }  

}

