part of 'extensions_bloc.dart';

enum ExtensionsLoadState { None, Loading , Error }

class ExtensionsState extends Equatable {
  ExtensionsLoadState loadState = ExtensionsLoadState.None;
  ExtensionsLoadState libaryLoadState = ExtensionsLoadState.None;
  List<ExtensionInfo> localExtensions = [];
  List<ExtensionInfo> extensionInfo = [];
  

  ExtensionsState({
    this.loadState = ExtensionsLoadState.None,
    this.libaryLoadState = ExtensionsLoadState.None,
    
    this.localExtensions = const [],
    this.extensionInfo = const [],
  });

  ExtensionsState copyWith({
    ExtensionsLoadState? loadState,
    ExtensionsLoadState? libaryLoadState,
    List<ExtensionInfo>? localExtensions,
    List<ExtensionInfo>? extensionInfo,

  }) =>
      ExtensionsState(
        loadState: loadState ?? this.loadState,
        libaryLoadState: libaryLoadState ?? this.libaryLoadState,
        
        localExtensions: localExtensions ?? this.localExtensions,
        extensionInfo: extensionInfo ?? this.extensionInfo,
      );

  @override
  List<Object?> get props => [loadState,localExtensions,extensionInfo,libaryLoadState];
}
