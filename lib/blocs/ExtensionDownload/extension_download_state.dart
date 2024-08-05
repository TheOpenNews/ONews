part of 'extension_download_bloc.dart';

enum ExtensionDownloadStatus { None, Completed, Failed }

class ExtensionDownloadState extends Equatable {
  ExtensionDownloadStatus downloadStatus;
  String apkName;

  ExtensionDownloadState({
    this.downloadStatus = ExtensionDownloadStatus.None,
    this.apkName = "",
  });

  ExtensionDownloadState copyWith({
    ExtensionDownloadStatus? downloadStatus,
    String? apkName,
  }) =>
      ExtensionDownloadState(
        downloadStatus: downloadStatus ?? ExtensionDownloadStatus.None,
        apkName: apkName ?? this.apkName,
      );

  @override
  List<Object?> get props => [downloadStatus,apkName];
}
