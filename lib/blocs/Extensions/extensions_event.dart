part of 'extensions_bloc.dart';

@immutable
sealed class ExtensionsEvent {}


class LoadExtensionsInfo extends ExtensionsEvent {}
class DownloadExtensionApk extends ExtensionsEvent {
  String apkURL;
  DownloadExtensionApk(this.apkURL);
}

