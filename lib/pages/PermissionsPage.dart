import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/blocs/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/blocs/Permission/permission_cubit.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/pages/ui/BottomNavBarWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsPage extends StatefulWidget {
  PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  Future<dynamic> checkStoragePermission() async {
    return await Permission.storage.isGranted;
  }

  Future<dynamic> checkPackageInstallPermission() async {
    return await Permission.requestInstallPackages.isGranted;
  }

  void onStoragePermission() async {
    await Permission.storage.request();
    setState(() {});
  }

  void onPackageInstallPermission() async {
    await Permission.requestInstallPackages.request();
    setState(() {});
  }

  void init() async {
    context
        .read<PermissionCubit>()
        .setStoragePermission((await checkStoragePermission()) as bool);
    context
        .read<PermissionCubit>()
        .setPackagePermission((await checkPackageInstallPermission()) as bool);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _appbarWidget(),
          body: Stack(
            children: [
              BlocBuilder<PermissionCubit, PermissionState>(
                builder: (context, state) {
                  if (!state.packagePermission || !state.storagePermission) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: 32,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Permissions For Extensions",
                              style: TextStyle(
                                  fontVariations: [FontVariation("wght", 700)],
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 20),
                          _permission_row_widget(
                              "Storage",
                              checkStoragePermission,
                              onStoragePermission,
                              "Storage is used to download extensions and store extensions to your device"),
                          SizedBox(height: 16),
                          _permission_row_widget(
                              "Install Extensions",
                              checkPackageInstallPermission,
                              onPackageInstallPermission,
                              "Installing Extensions is used so you can access and manage them localy"),
                        ],
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
              Positioned(
                bottom: 0,
                child: BottomNavBarWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _appbarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "ONews",
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
              fontVariations: [FontVariation('wght', 700)],
            ),
          ),
        ],
      ),
      elevation: 2,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.1),
    );
  }

  Widget _permission_row_widget(title, checkCallback, onAskCallback, info) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.4),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontVariations: [FontVariation("wght", 600)],
              fontSize: 18,
            ),
          ),
          FutureBuilder(
            future: checkCallback(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    !snapshot.data
                        ? IconButton(
                            onPressed: onAskCallback,
                            icon: Icon(
                              Icons.circle_outlined,
                              color: Colors.grey,
                            ),
                          )
                        : IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.check_circle,
                              color: CColors.primaryBlue,
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              info,
                              style: TextStyle(
                                fontVariations: [FontVariation("wght", 500)],
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.info_rounded,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
