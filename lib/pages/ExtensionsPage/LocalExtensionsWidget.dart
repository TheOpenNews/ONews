import 'package:anynews/NativeInterface.dart';
import 'package:anynews/blocs/Extensions/extensions_bloc.dart';
import 'package:anynews/pages/ExtensionsPage/LocalExtensionsCardWidget.dart';
import 'package:anynews/repos/ExtensionsRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalExtensionsWidget extends StatefulWidget {
  const LocalExtensionsWidget({
    super.key,
  });

  @override
  State<LocalExtensionsWidget> createState() => _LocalExtensionsWidgetState();
}

class _LocalExtensionsWidgetState extends State<LocalExtensionsWidget> {
  void loadLocalExtensions() async {
    var data = await NativeInterface.loadLocalExtensions();
    context.read<ExtensionsRepo>().loadLocalExtensions(data);
    context.read<ExtensionsBloc>().add(
        LoadLocalExtension(context.read<ExtensionsRepo>().localExtensions));
  }

  @override
  void initState() {
    loadLocalExtensions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onLoadExtensions() async {}

    return BlocBuilder<ExtensionsBloc, ExtensionsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Extensions:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...state.localExtensions
                .map((info) => LocalExtensionsCardWidget(
                      info: info,
                    ))
                .toList(),
          ],
        );
      },
    );
  }
}
