import 'package:flutter/material.dart';
import 'package:onews/Ui/LoadingLineWidget.dart';

class HeadlineCardLoadingWidget extends StatelessWidget {
  HeadlineCardLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.3),
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[300],
            ),
            child: Container(),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingLineWidget(width: 80,color : Colors.grey[300]!),
                SizedBox(height: 16),
                LoadingLineWidget(width: double.infinity,color: Colors.grey[300]!,),
                SizedBox(height: 8),
                LoadingLineWidget(width: double.infinity,color: Colors.grey[300]!,),
                SizedBox(height: 8),
                LoadingLineWidget(width: double.infinity,color: Colors.grey[300]!,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
