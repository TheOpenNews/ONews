part of 'extension_download_bloc.dart';

sealed class ExtensionDownloadEvent {}

class CompeletedTheExtensionDownload extends ExtensionDownloadEvent {}
class FailedTheExtensionDownload extends ExtensionDownloadEvent {}
class DownloadExtensionApk extends ExtensionDownloadEvent {
  String apkURL;
  String apkName;
  DownloadExtensionApk(this.apkURL,this.apkName);
}

class InstallExtensionApk extends ExtensionDownloadEvent {}