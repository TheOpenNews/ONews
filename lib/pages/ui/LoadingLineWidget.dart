
import 'package:flutter/material.dart';

class LoadingLineWidget extends StatelessWidget {
  LoadingLineWidget({
    super.key,
    this.color = Colors.grey,
    required this.width
  });
  double width;
  Color color =  Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
      child: Container(),
    );
  }
}
