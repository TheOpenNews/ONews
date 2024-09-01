import 'package:flutter/material.dart';
import 'package:onews/consts/Colors.dart';
import 'package:onews/consts/Utils.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  List<Widget> actions;
  CustomAppBarWidget({
    super.key,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  
                  text: "O",
                  style: TextStyle(
                    color: CColors.primaryBlue,
                    fontVariations: Utils.setFontWeight(800),
              fontSize: 27,
                  ),
                ),
                TextSpan(
                  text: "News",
                  style: TextStyle(
                    fontVariations: Utils.setFontWeight(600),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              fontSize: 26,
              fontFamily: 'Raleway'
            ),
          ),
        ],
      ),
      actions: actions,
      elevation: 2,
      
      surfaceTintColor: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.1),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
