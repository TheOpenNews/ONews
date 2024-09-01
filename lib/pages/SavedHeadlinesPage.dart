import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/Ui/CustomAppBarWidget.dart';
import 'package:onews/cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/modules/HeadlineCard.dart';
import 'package:onews/repos/SavedNewsRepo.dart';



class SavedHeadlinesPage extends StatefulWidget {
  SavedHeadlinesPage({super.key});

  @override
  State<SavedHeadlinesPage> createState() => _SavedHeadlinesPageState();
}

class _SavedHeadlinesPageState extends State<SavedHeadlinesPage> {
  List<HeadlineCard> cards = [];


  @override
  void initState() {
    super.initState();
    // context.read<SavedNewsRepo>().loadSavedNews();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWidget(),
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
