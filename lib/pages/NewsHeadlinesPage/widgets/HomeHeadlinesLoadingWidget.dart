

import 'package:flutter/material.dart';
import 'package:onews/consts/Colors.dart';

class HomeHeadlinesLoadingWidget extends StatelessWidget {
  HomeHeadlinesLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 200,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.4),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: CColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}
