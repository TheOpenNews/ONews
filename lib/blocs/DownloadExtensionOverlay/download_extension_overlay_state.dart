part of 'download_extension_overlay_bloc.dart';

class DownloadExtensionOverlayState extends Equatable {
  int status = 0;
  bool showOverlay = false;

  DownloadExtensionOverlayState({
    this.status = 0,
    this.showOverlay = false,
  });

  DownloadExtensionOverlayState copyWith({
    int? status,
    bool? showOverlay,
  }) =>
      DownloadExtensionOverlayState(
        status: status ?? this.status,
        showOverlay: showOverlay ?? this.showOverlay,
      );

  @override
  List<Object> get props => [
        status,
        showOverlay,
      ];
}
