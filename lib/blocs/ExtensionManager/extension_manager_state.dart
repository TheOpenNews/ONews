part of 'extension_manager_bloc.dart';

enum ExtensionsLoadState { None, Loading , Error }

class ExtensionManagerState extends Equatable {
  ExtensionsLoadState loadState = ExtensionsLoadState.None;
  ExtensionsLoadState libaryLoadState = ExtensionsLoadState.None;
  List<ExtensionInfo> localExtensions = [];
  List<ExtensionInfo> extensionInfo = [];
  

  ExtensionManagerState({
    this.loadState = ExtensionsLoadState.None,
    this.libaryLoadState = ExtensionsLoadState.None,
    
    this.localExtensions = const [],
    this.extensionInfo = const [],
  });

  ExtensionManagerState copyWith({
    ExtensionsLoadState? loadState,
    ExtensionsLoadState? libaryLoadState,
    List<ExtensionInfo>? localExtensions,
    List<ExtensionInfo>? extensionInfo,

  }) =>
      ExtensionManagerState(
        loadState: loadState ?? this.loadState,
        libaryLoadState: libaryLoadState ?? this.libaryLoadState,
        
        localExtensions: localExtensions ?? this.localExtensions,
        extensionInfo: extensionInfo ?? this.extensionInfo,
      );

  @override
  List<Object?> get props => [loadState,localExtensions,extensionInfo,libaryLoadState];
}
