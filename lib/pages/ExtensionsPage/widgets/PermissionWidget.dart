import 'package:onews/cubits/Permission/permission_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/consts/Colors.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWidget extends StatefulWidget {
  const PermissionWidget({
    super.key,
  });

  @override
  State<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> {
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
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
        builder: (context, state) {
      if (!state.packagePermission || !state.storagePermission) {
        return Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Permissions For Extensions",
                style: TextStyle(
                    fontVariations: [FontVariation("wght", 700)], fontSize: 20),
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
        );
      }
      return SizedBox();
    });
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
            color: Colors.grey.withOpacity(0.2),
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
