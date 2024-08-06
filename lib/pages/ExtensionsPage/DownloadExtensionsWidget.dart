import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/blocs/Permission/permission_cubit.dart';
import 'package:anynews/pages/ExtensionsPage/DownloadExtensionsCardWidget.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadExtensionsWidget extends StatefulWidget {
  const DownloadExtensionsWidget({
    super.key,
  });

  @override
  State<DownloadExtensionsWidget> createState() =>
      _DownloadExtensionsWidgetState();
}

class _DownloadExtensionsWidgetState extends State<DownloadExtensionsWidget> {
  void onClick() async {}

  void onStoragePermission() async {
    Permission.storage.request();
  }

  void onExtensionsPermission() async {
    Permission.requestInstallPackages.request();
  }

  @override
  void initState() {
    super.initState();
    context.read<ExtensionsBloc>().add(LoadExtensionsInfo());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsBloc, ExtensionsState>(
      builder: (context, state) {
        return Column(
          children: [
            PermissionWidget(),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Avaible Extensions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 16),
            ...context
                .read<ExtensionsRepo>()
                .extensionsInfoList
                .map(
                  (info) => DownloadExtensionsCardWidget(info: info),
                )
                .toList(),
            SizedBox(height: 16),
            state.loadState == ExtensionsLoadState.Loading
                ? CircularProgressIndicator()
                : SizedBox(),
          ],
        );
      },
    );
  }
}

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
              child: Text("Permissions"),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.grey.withOpacity(0.1),
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _permission_row_widget(
                    "Storage",
                    checkStoragePermission,
                    onStoragePermission,
                  ),
                  SizedBox(height: 8),
                  _permission_row_widget(
                    "Extensions",
                    checkPackageInstallPermission,
                    onPackageInstallPermission,
                  ),
                ],
              ),
            ),
          ],
        );
      }
      return SizedBox();
    });
  }

  Widget _permission_row_widget(title, checkCallback, onAskCallback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        FutureBuilder(
          future: checkCallback(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return !snapshot.data
                  ? ElevatedButton(
                      onPressed: onAskCallback,
                      child: Text(
                        "Give Permission",
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF6c757d),
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF2e9846),
                        weight: 40.0,
                      ),
                    );
            }
            return CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
