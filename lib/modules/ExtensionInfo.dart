import 'package:onews/consts/Urls.dart';
import 'package:equatable/equatable.dart';

class ExtensionInfo extends Equatable {
  String name = "";
  String logoURL = "";
  String siteURL = "";
  String apkURL = "";
  String apkName = "";
  String version = "";
  String base64Icon = "";
  List<String> categories = [];

  ExtensionInfo({
    this.name = "",
    this.siteURL = "",
    this.logoURL = "",
    this.apkName = "",
    this.base64Icon = "",
    this.categories = const [],
    this.version = "",
  }) {
    this.apkURL = Urls.ExtensionApkDir + "/" + this.apkName;
  }

  @override
  String toString() {
    return "ExtensionInfo(name: $name, siteURL: ...)";
  }

  @override
  List<Object?> get props =>
      [name, logoURL, siteURL, apkURL, base64Icon, categories, version];
}
