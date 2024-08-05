part of 'extensions_bloc.dart';

@immutable
sealed class ExtensionsEvent {}


class LoadExtensionsInfo extends ExtensionsEvent {}
class LoadLocalExtension extends ExtensionsEvent {
  List<ExtensionInfo> localExtensions;
  LoadLocalExtension(this.localExtensions);
}

