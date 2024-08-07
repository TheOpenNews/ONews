


import 'package:flutter/material.dart';

class TextElemWidget extends StatelessWidget {
  TextElemWidget({
    super.key,
    required this.text,
  });
  String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
