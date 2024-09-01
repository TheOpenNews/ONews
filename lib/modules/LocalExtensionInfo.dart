import 'package:equatable/equatable.dart';

class LocalExtensionInfo extends Equatable {
  String ID = "";
  String name = "";
  String logoURL = "";
  String siteURL = "";
  String version = "";
  String packageName = "";
  List<String> categories = [];

  LocalExtensionInfo({
    this.name = "",
    this.siteURL = "",
    this.logoURL = "",
    this.packageName = "",
    this.categories = const [],
    this.version = "",
  });

  @override
  String toString() {
    return "LocalExtensionInfo(name: $name)";
  }

  @override
  List<Object?> get props => [ID ,packageName, name, logoURL, siteURL, categories, version];
}
