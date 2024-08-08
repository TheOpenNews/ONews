import 'package:onews/NativeInterface.dart';
import 'package:onews/blocs/Extensions/extensions_bloc.dart';
import 'package:onews/pages/ExtensionsPage/LocalExtensionsCardWidget.dart';
import 'package:onews/repos/ExtensionsRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    context.read<ExtensionsRepo>().loadLocalExtensions(data!);
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Builder(builder: (context) {
              if (state.localExtensions.length == 0) {
                return Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "You have no local extensions, go download some :L",
                        textAlign: TextAlign.center,
                    
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              }

              return Column(children: [
                ...state.localExtensions
                    .map((info) => LocalExtensionsCardWidget(
                          info: info,
                        ))
                    .toList()
              ]);
            })
          ],
        );
      },
    );
  }
}
