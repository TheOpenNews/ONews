part of 'extensions_bloc.dart';

enum ExtensionsLoadState { None, Loading }

class ExtensionsState extends Equatable {
  ExtensionsLoadState loadState = ExtensionsLoadState.None;

  ExtensionsState({
    this.loadState = ExtensionsLoadState.None,
  });

  ExtensionsState copyWith({
    ExtensionsLoadState? loadState,
  }) =>
      ExtensionsState(
        loadState: loadState ?? ExtensionsLoadState.None,
      );

  @override
  List<Object?> get props => [loadState];
}
