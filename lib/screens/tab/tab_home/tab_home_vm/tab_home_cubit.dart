import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'tab_home_state.dart';

class TabHomeCubit extends Cubit<TabHomeState> {
  final CategoryRepository categoryRepository;

  TabHomeCubit({required this.categoryRepository}) : super(TabHomeState.initial());

  Future<void> initCubit() async {
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(categoriesLoading: true, categoriesError: null));

    final result = await categoryRepository.getAllCategory();

    if (result.isSuccess && result.content != null) {
      emit(state.copyWith(
        categories: result.content,
        categoriesLoading: false,
        categoriesError: null,
      ));
    } else {
      emit(state.copyWith(
        categoriesLoading: false,
        categoriesError: result.message,
        categories: [],
      ));
    }
  }

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

  void onCategoryTap(Category category) {
  }

  void onProductTap(int index) {
  }

  void onFavoriteTap(int index) {
  }
}