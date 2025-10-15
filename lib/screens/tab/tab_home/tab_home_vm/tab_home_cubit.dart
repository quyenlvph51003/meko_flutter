import 'package:flutter_bloc/flutter_bloc.dart';
import 'tab_home_state.dart';

class TabHomeCubit extends Cubit<TabHomeState> {
  TabHomeCubit() : super(TabHomeState.initial());

  void changeTab(String tabName) {
    if (state.selectedTab != tabName) {
      emit(state.copyWith(selectedTab: tabName));
    }
  }

  void updateAppBarCollapsed(bool isCollapsed) {
    if (state.isAppBarCollapsed != isCollapsed) {
      emit(state.copyWith(isAppBarCollapsed: isCollapsed));
    }
  }

  void requestLocationPermission() {

  }

  void onSearchTap() {

  }

  void onCategoryTap(CategoryItem category) {

  }

  void onProductTap(int index) {

  }

  void onFavoriteTap(int index) {

  }
}