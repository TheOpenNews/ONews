import 'package:flutter/material.dart';

class ImageElemWidget extends StatelessWidget {
  ImageElemWidget({super.key, required this.src});

  String src;

  @override
  Widget build(BuildContext context) {
    return Image.network(src);
  }
}