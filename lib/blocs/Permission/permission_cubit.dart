import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionState());



  void setStoragePermission(val) {
    emit(state.copyWith(storagePermission: val));
  }
  void setPackagePermission(val) {
    emit(state.copyWith(packagePermission: val));
  }

}
