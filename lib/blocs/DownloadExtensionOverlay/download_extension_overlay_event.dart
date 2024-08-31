part of 'download_extension_overlay_bloc.dart';

class DownloadExtensionOverlayEvent extends Equatable {
  const DownloadExtensionOverlayEvent();
  @override
  List<Object> get props => [];
}


class ShowDownloadingOverlay extends DownloadExtensionOverlayEvent { }
class HideDownloadingOverlay extends DownloadExtensionOverlayEvent { }
class UpdateDownloadStatus extends DownloadExtensionOverlayEvent { 
  int status;
  UpdateDownloadStatus(this.status); 
}
