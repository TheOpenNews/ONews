part of 'permission_cubit.dart';

class PermissionState extends Equatable {
  bool storagePermission = false;
  bool packagePermission = false;

  PermissionState({
    this.storagePermission = false,
    this.packagePermission = false,
  });

  PermissionState copyWith({
    bool? storagePermission,
    bool? packagePermission,
  }) =>
      PermissionState(
        storagePermission: storagePermission ?? this.storagePermission,
        packagePermission: packagePermission ?? this.packagePermission,
      );

  @override
  List<Object> get props => [storagePermission, packagePermission];
}
