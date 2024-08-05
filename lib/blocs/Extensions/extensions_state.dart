part of 'extensions_bloc.dart';

enum ExtensionsLoadState { None, Loading }

class ExtensionsState extends Equatable {
  ExtensionsLoadState loadState = ExtensionsLoadState.None;
  List<ExtensionInfo> localExtensions = [];
  

  ExtensionsState({
    this.loadState = ExtensionsLoadState.None,
    this.localExtensions = const [],
  });

  ExtensionsState copyWith({
    ExtensionsLoadState? loadState,
    List<ExtensionInfo>? localExtensions,
  }) =>
      ExtensionsState(
        loadState: loadState ?? ExtensionsLoadState.None,
        localExtensions: localExtensions ?? this.localExtensions,
      );

  @override
  List<Object?> get props => [loadState,localExtensions];
}
