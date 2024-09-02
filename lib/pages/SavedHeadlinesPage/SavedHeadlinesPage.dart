import 'package:flutter/cupertino.dart';
import 'package:onews/Ui/BottomNavBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/Ui/CustomAppBarWidget.dart';
import 'package:onews/consts/LocalStorage.dart';
import 'package:onews/cubits/BottomNavBar/bottom_nav_bar_cubit.dart';
import 'package:onews/cubits/SavedNews/saved_news_cubit.dart';
import 'package:onews/modules/News.dart';
import 'package:onews/pages/NewsHeadlinesPage/widgets/HeadlineCardWidget.dart';
import 'package:onews/pages/SavedHeadlinesPage/SavedHeadlineCardWidget.dart';
import 'package:onews/repos/SavedNewsRepo.dart';

class SavedHeadlinesPage extends StatefulWidget {
  SavedHeadlinesPage({super.key});

  @override
  State<SavedHeadlinesPage> createState() => _SavedHeadlinesPageState();
}

class _SavedHeadlinesPageState extends State<SavedHeadlinesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedNewsCubit, SavedNewsState>(
      builder: (context, state) {
        var savedNews = LocalStorage.loadSavedNews();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBarWidget(),
          body: Stack(
            children: [
              FutureBuilder(
                  future: LocalStorage.loadSavedNews(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, PreviewNewsData>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return SizedBox();
                    }
                    if(snapshot.data == null) {
                      return SizedBox();
                    }
                    debugPrint(snapshot.data.toString());

                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...state.savedNewsIds.map((uuid) {
                              debugPrint(uuid);
                              return SavedHeadlineCardWidget(
                                data: snapshot.data![uuid]!,
                              );
                            }).toList(),
                            SizedBox(height: 54),
                          ],
                        ),
                      ),
                    );
                  }),
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
