part of 'extensions_bloc.dart';

enum ExtensionsLoadState { None, Loading , Error }

class ExtensionsState extends Equatable {
  ExtensionsLoadState loadState = ExtensionsLoadState.None;
  List<ExtensionInfo> localExtensions = [];
  List<ExtensionInfo> extensionInfo = [];
  

  ExtensionsState({
    this.loadState = ExtensionsLoadState.None,
    this.localExtensions = const [],
    this.extensionInfo = const [],
  });

  ExtensionsState copyWith({
    ExtensionsLoadState? loadState,
    List<ExtensionInfo>? localExtensions,
    List<ExtensionInfo>? extensionInfo,
  }) =>
      ExtensionsState(
        loadState: loadState ?? ExtensionsLoadState.None,
        localExtensions: localExtensions ?? this.localExtensions,
        extensionInfo: extensionInfo ?? this.extensionInfo,
      );

  @override
  List<Object?> get props => [loadState,localExtensions,extensionInfo];
}
