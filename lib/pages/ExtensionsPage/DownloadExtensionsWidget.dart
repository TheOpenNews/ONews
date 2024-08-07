import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/blocs/Permission/permission_cubit.dart';
import 'package:anynews/pages/ExtensionsPage/DownloadExtensionsCardWidget.dart';
import 'package:anynews/pages/ExtensionsPage/PermissionWidget.dart';
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
                ?  CircularProgressIndicator()
                : SizedBox(),
          ],
        );
      },
    );
  }
}

