part of 'extension_manager_bloc.dart';

@immutable
sealed class ExtensionManagerEvent {}
class QueryExtensionsInfo extends ExtensionManagerEvent {}
class LoadLocalExtension extends ExtensionManagerEvent {}

