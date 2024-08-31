part of 'download_extension_apk_bloc.dart';

sealed class DownloadExtensionApkEvent {}

class CompeletedDownloadingExtensionApk extends DownloadExtensionApkEvent {}
class FailedDownloadingExtensionApk extends DownloadExtensionApkEvent {}
class InstallExtensionApk extends DownloadExtensionApkEvent {}
class StartDownloadingExtensionApk extends DownloadExtensionApkEvent {
  String apkURL;
  ExtensionInfo ext_info;
  StartDownloadingExtensionApk(this.apkURL,this.ext_info);
}
