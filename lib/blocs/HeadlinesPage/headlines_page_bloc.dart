import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onews/NativeInterface.dart';
import 'package:onews/consts/Utils.dart';
import 'package:onews/modules/ExtensionInfo.dart';
import 'package:onews/modules/HeadlineCard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'headlines_page_event.dart';
part 'headlines_page_state.dart';

class HeadlinesPageBloc extends Bloc<HeadlinesPageEvent, HeadlinesPageState> {
  String _curCategory = "";
  HeadlinesPageBloc()
      : super(
          HeadlinesPageState(
            extensionInfo: ExtensionInfo(),
            latestEvent: SelectPage(),
            selectedCard: HeadlineCard(),
          ),
        ) {

    on<SelectExtension>(onSelectExtension);
    on<NextPage>(onNextPage);
    on<ChangeCategory>(onChangeCategory);
    on<SelectPage>(onSelectPage);
    on<LoadHomePageHeadlines>(onLoadHomePageHeadlines);
  }

  void onSelectExtension(SelectExtension event, emit) async {
    emit(
      state.copyWith(
        extensionInfo: event.info,
        loadingStatus: NewsCardsLoadingStatus.Loading,
        homePageHeadlinesState: HomePageHeadlinesState.Loading,
        newsCards: [],
        homePageHeadlines: [],
      ),
    );

    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      event.info,
      category: event.info.categories[0],
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      debugPrint(data.toString());
      emit(
        state.copyWith(
          newsCards: Utils.parseJsonDataToHeadlines(data["data"]),
          loadingStatus: NewsCardsLoadingStatus.None,
        ),
      );
    }
  }

  void onNextPage(NextPage event, emit) async {
    emit(state.copyWith(loadingStatus: NewsCardsLoadingStatus.Loading));
    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: state.page + 1,
      category: state.category,
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            latestEvent: event,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      emit(state.copyWith(
        page: state.page + 1,
        newsCards: state.newsCards = [
          ...state.newsCards,
          ...Utils.parseJsonDataToHeadlines(data["data"])
        ],
        loadingStatus: NewsCardsLoadingStatus.None,
      ));
    }
  }

  void onChangeCategory(ChangeCategory event, emit) async {
    _curCategory = event.category;
    emit(
      state.copyWith(
        newsDone: false,
        category: event.category,
        page: 1,
        newsCards: [],
        loadingStatus: NewsCardsLoadingStatus.Loading,
      ),
    );

    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: 1,
      category: event.category,
    );

    if (_curCategory != event.category) {
      return;
    }

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            latestEvent: event,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      emit(state.copyWith(
        page: 1,
        newsCards: state.newsCards = [
          ...state.newsCards,
          ...Utils.parseJsonDataToHeadlines(data["data"])
        ],
        loadingStatus: NewsCardsLoadingStatus.None,
      ));
    }
  }

  void onSelectPage(SelectPage event, emit) async {
    emit(
      state.copyWith(
        loadingStatus: NewsCardsLoadingStatus.Loading,
        newsCards: [],
      ),
    );
    Map<String, dynamic> data = await NativeInterface.loadNewsHeadlines(
      state.extensionInfo,
      page: event.page,
      category: state.category,
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (error["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            newsDone: true,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            loadingStatus: NewsCardsLoadingStatus.Failed,
            latestEvent: event,
            errorMsg: error["msg"],
            errorType: error["type"],
          ),
        );
      }
    } else {
      emit(state.copyWith(
        page: event.page,
        newsCards: state.newsCards = [
          ...state.newsCards,
          ...Utils.parseJsonDataToHeadlines(data["data"])
        ],
        loadingStatus: NewsCardsLoadingStatus.None,
      ));
    }
  }

  void onLoadHomePageHeadlines(event, emit) async {
    emit(
      state.copyWith(
        homePageHeadlinesState: HomePageHeadlinesState.Loading,
      ),
    );
    await Future.delayed(Duration(seconds: 4));
    Map<String, dynamic> data = await NativeInterface.scrapeHomePage(
      state.extensionInfo,
    );

    if (data.keys.contains("error")) {
      Map<String, String> error = Map<String, String>();
      (data["error"] as Map).forEach((key, value) {
        error[key] = value;
      });

      if (data["type"] == "NoHeadlines") {
        emit(
          state.copyWith(
            homePageHeadlinesState: HomePageHeadlinesState.Loading,
            newsDone: true,
            errorMsg: data["msg"],
            errorType: data["type"],
          ),
        );
      } else {
        emit(
          state.copyWith(
            homePageHeadlinesState: HomePageHeadlinesState.Loading,
            latestEvent: event,
            errorMsg: data["msg"],
            errorType: data["type"],
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          homePageHeadlinesState: HomePageHeadlinesState.None,
          homePageHeadlines: Utils.parseJsonDataToHeadlines(data["data"]),
        ),
      );
    }
  }
}
