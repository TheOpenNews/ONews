// ignore_for_file: must_be_immutable

part of 'download_extension_apk_bloc.dart';

enum ExtensionDownloadStatus { None, Completed, Failed }

class DownloadExtensionApkState extends Equatable {
  ExtensionInfo? ext_info;
  ExtensionDownloadStatus downloadStatus;

  DownloadExtensionApkState({
    this.downloadStatus = ExtensionDownloadStatus.None,
    this.ext_info = null,
  });

  DownloadExtensionApkState copyWith({
    ExtensionDownloadStatus? downloadStatus,
    ExtensionInfo? ext_info,
    String? apkName,
  }) =>
      DownloadExtensionApkState(
        downloadStatus: downloadStatus ?? ExtensionDownloadStatus.None,
        ext_info: ext_info ?? this.ext_info,
        
      );

  @override
  List<Object?> get props => [downloadStatus,ext_info];
}
