import 'package:equatable/equatable.dart';

class ExtensionInfo extends Equatable {
  String name = "";
  String logoURL = "";
  String siteURL = "";
  String apkURL = "";

  ExtensionInfo(this.name, this.siteURL, this.logoURL, this.apkURL);

  @override
  String toString() {
    return "ExtensionInfo(name: $name, siteURL: ${siteURL.substring(0, 16)}...)";
  }

  @override
  List<Object?> get props => [
        name,
        logoURL,
        siteURL,
        apkURL,
      ];
}
