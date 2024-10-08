import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/Ui/CustomAppBarWidget.dart';
import 'package:onews/cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/cubits/Permission/permission_cubit.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsPage extends StatefulWidget {
  PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  Future<dynamic> checkStoragePermission() async {
    return await Permission.manageExternalStorage.isGranted;
  }

  Future<dynamic> checkPackageInstallPermission() async {
    return await Permission.requestInstallPackages.isGranted;
  }

  void onStoragePermission() async {
    await Permission.manageExternalStorage.request();
    setState(() {});
  }

  void onPackageInstallPermission() async {
    await Permission.requestInstallPackages.request();
    setState(() {});
  }

  void init() async {
    context.read<PermissionCubit>().setStoragePermission((await checkStoragePermission()) as bool);
    context.read<PermissionCubit>().setPackagePermission((await checkPackageInstallPermission()) as bool);
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWidget(),
          body: Stack(
            children: [
              BlocBuilder<PermissionCubit, PermissionState>(
                builder: (context, state) {
                  debugPrint((!state.packagePermission).toString() + (!state.storagePermission).toString());
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
