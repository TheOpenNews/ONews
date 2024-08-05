import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/pages/ExtensionsPage/ExtensionDownloadCardWidget.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadExtensionsWidget extends StatelessWidget {
  const DownloadExtensionsWidget({
    super.key,
  });

  void onClick() async {}

  void onStoragePermission() async {
    Permission.storage.request();
  }

  void onExtensionsPermission() async {
    Permission.requestInstallPackages.request();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExtensionsBloc, ExtensionsState>(
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () => onStoragePermission(),
              child: Text("Permission Storage"),
            ),
            ElevatedButton(
              onPressed: () => onExtensionsPermission(),
              child: Text("Permission Extensions"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onClick(),
              child: Text("Download"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<ExtensionsBloc>().add(LoadExtensionsInfo()),
              child: Text("Load Extension List"),
            ),
            SizedBox(height: 16),
            state.loadState == ExtensionsLoadState.Loading
                ? CircularProgressIndicator()
                : SizedBox(),
            SizedBox(height: 16),
            ...context
                .read<ExtensionsRepo>()
                .extensionsInfoList
                .map(
                  (info) => ExtensionDownloadCardWidget(info: info),
                )
                .toList(),
          ],
        );
      },
    );
  }
}
