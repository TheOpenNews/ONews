part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  var curIdx;
  
  BottomNavBarState(this.curIdx);
  @override
  List<Object> get props => [curIdx];
}

