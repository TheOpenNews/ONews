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

  void onStoragePermission() async {
    Permission.storage.request();
  }

  void onExtensionsPermission() async {
    Permission.requestInstallPackages.request();
  }

  @override
  void initState() {
    super.initState();
    if(!interentError) {
    context.read<ExtensionsBloc>().add(LoadExtensionsInfo());
    }
  }

  void onTryAgain() {
    setState(() {
      interentError = false;
    });
    context.read<ExtensionsBloc>().add(LoadExtensionsInfo());
  }

  bool interentError = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExtensionsBloc, ExtensionsState>(
      listener: (context, state) {
        if (state.loadState == ExtensionsLoadState.Error && !interentError) {
          setState(() {
            interentError = true;
          });
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to extensions, check your interent connection",
              ),
            ),
          );
        }
      },
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
            Builder(
              builder: (context) {
                var extensionsList =
                    context.read<ExtensionsRepo>().extensionsInfoList;
                if (state.loadState == ExtensionsLoadState.Error) {
                  return ElevatedButton(
                      onPressed: onTryAgain, child: Text("Try Again"));
                }
                return Column(
                  children: [
                    ...extensionsList
                        .map(
                          (info) => DownloadExtensionsCardWidget(info: info),
                        )
                        .toList(),
                  ],
                );
              },
            ),
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
