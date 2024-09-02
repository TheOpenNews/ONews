import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class LocalExtensionInfo extends Equatable {
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

  Map<String, dynamic> convertToJson() {
    return {
      "name": name,
      "logoURL": logoURL,
      "siteURL": siteURL,
      "version": version,
      "packageName": packageName,
      "categories": jsonEncode(categories),
    };
  }

  factory LocalExtensionInfo.fromJson(Map<dynamic, dynamic> data) {
    debugPrint(data["categories"].toString());
    return LocalExtensionInfo(
      name: data["name"],
      logoURL: data["logoURL"],
      siteURL: data["siteURL"],
      version: data["version"],
      packageName: data["packageName"],
      categories: (jsonDecode(data["categories"]) as List<dynamic>).map((elem) => elem.toString()).toList(),
    );
  }

  @override
  String toString() {
    return "LocalExtensionInfo(name: $name)";
  }

  @override
  List<Object?> get props =>
      [packageName, name, logoURL, siteURL, categories, version];
}
