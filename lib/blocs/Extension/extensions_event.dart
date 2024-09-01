part of 'extensions_bloc.dart';

sealed class ExtensionsEvent {}
class QueryExtensionsInfo extends ExtensionsEvent {}
class LoadLocalExtension extends ExtensionsEvent {}

