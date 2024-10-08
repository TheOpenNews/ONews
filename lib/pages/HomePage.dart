import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/Ui/CustomAppBarWidget.dart';
import 'package:onews/cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/modules/HeadlineCard.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  List<HeadlineCard> cards = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWidget(),
          // bottomNavigationBar: BottomNavBarWidget(),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sorry not implemented yet",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      ":P",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: BottomNavBarWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
