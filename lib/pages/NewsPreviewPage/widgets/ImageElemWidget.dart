import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageElemWidget extends StatelessWidget {
  ImageElemWidget({super.key, required this.src});

  String src;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl:  src);
  }
}