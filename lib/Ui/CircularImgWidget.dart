
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularImgWidget extends StatelessWidget {
  const CircularImgWidget({
    super.key,
    required this.imgURL,
  });

  final String imgURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: imgURL,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}