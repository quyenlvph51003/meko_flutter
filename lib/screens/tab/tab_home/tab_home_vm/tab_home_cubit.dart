import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'tab_home_state.dart';

class TabHomeCubit extends Cubit<TabHomeState> {
  final CategoryRepository categoryRepository;
  final PostRepo postRepository;

  TabHomeCubit({required this.categoryRepository, required this.postRepository}) : super(TabHomeState.initial());

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

  Future<void> fetchPosts() async {
    emit(state.copyWith(postsLoading: true, postsError: null));

    final result = await postRepository.getPosts();

    if (result.success && result.data != null) {
      emit(state.copyWith(
        posts: result.data!.content,
        postsPagination: result.data!.pagination,
        postsLoading: false,
        postsError: null,
      ));
    } else {
      emit(state.copyWith(
        postsLoading: false,
        postsError: result.message,
        posts: [],
      ));
    }
  }

  void onProductTap(BuildContext context, int index) {
    final item = state.posts[index];
    Navigator.pushNamed(
      context,
      AppRouterPaths.postDetailPage,
      arguments: {
        'item': item,
        'loader': (int id) => postRepository.getPostDetailItem(id),
      },
    );
  }


  void changeTab(String tabName) {
  }


  void requestLocationPermission() {
  }

  void onSearchTap() {
    // Navigator.pushNamed(context, AppRouterPaths.)
  }

  void onCategoryTap(Category category) {
  }


  void onFavoriteTap(int index) {
  }
}