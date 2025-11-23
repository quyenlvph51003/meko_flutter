import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/product/product_card_search.dart';
import 'tab_home_state.dart';

class TabHomeCubit extends Cubit<TabHomeState> {
  final CategoryRepository categoryRepository;
  final PostRepo postRepository;

  TabHomeCubit({required this.categoryRepository, required this.postRepository}) : super(TabHomeState.initial());

  Future<void> initCubit() async {
    await fetchCategories();
  }

  void selectedCategoryCubit(Category category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void onSearchProductTap(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.searchPage,
      arguments: {
        'onSearch': (String query) async {
          final result = await postRepository.getPosts(
            page: 0,
            size: 10,
            postSearchRequest: PostSearchRequest(
              searchText: query,
              status: PostStatus.APPROVED,
              categoryIds: state.selectedCategory?.id != 0 ? [?state.selectedCategory?.id] : null,
            ),
          );
          return result.data?.content ?? [];
        },
        'itemBuilder': (dynamic item) {
          return ItemProductSearch(
            imageUrl: item.images.isNotEmpty ? item.images.first : '',
            title: item.title,
            description: item.address,
            price: double.tryParse(item.price) ?? 0,
            onTap: () => onProductTap(context, 0),
          );
        },
        'onSelected': (dynamic item) {
          onProductTap(context, 0);
        },
        'hintText': 'Tìm kiếm bài viết...',
      },
    );
  }

  Future<void> fetchCategories() async {
    emit(state.copyWith(categoriesLoading: true, categoriesError: null));

    final result = await categoryRepository.getAllCategory();
    if (result.isSuccess && result.content != null) {
      final categories = List<Category>.from(result.content!);
      categories.add(Category(id: 0, name: 'Tất cả danh mục', avatar: AppImages.icon_all_categories, is_active: 1));

      emit(state.copyWith(categories: categories, categoriesLoading: false, categoriesError: null));
    } else {
      emit(state.copyWith(categoriesLoading: false, categoriesError: result.message, categories: []));
    }
  }
 
  Future<void> fetchPosts({int page = 0, bool? isLoadMore = false}) async {
    final user = await SqliteHelper.getUserSql();
    print(user?.id);
    if (isLoadMore ?? false) {
      emit(state.copyWith(page: page));
    } else {
      emit(state.copyWith(postsLoading: true, postsError: null, page: page));
    }
    final result = await postRepository.getPosts(
      page: page,
      size: 10,
      postSearchRequest: PostSearchRequest(status: PostStatus.APPROVED, userId: user?.id),
    );

    if (result.success && result.data != null) {
      if (isLoadMore ?? false) {
        print(result.data!.content.isEmpty);
        emit(
          state.copyWith(
            posts: [...state.posts, ...result.data!.content],
            postsPagination: result.data!.pagination,
            postsLoading: false,
            postsError: null,
            noMore: result.data!.content.isEmpty ? true : false,
          ),
        );
      } else {
        emit(state.copyWith(posts: result.data!.content, postsPagination: result.data!.pagination, postsLoading: false, postsError: null));
      }
    } else {
      emit(state.copyWith(postsLoading: false, postsError: result.message, posts: []));
    }
  }

  Future<void> onRefresh() async {
    emit(state.copyWith(categoriesLoading: true, categoriesError: null, postsLoading: true, postsError: null, page: 0, noMore: false));
    final resultCategories = await categoryRepository.getAllCategory();
    final user = await SqliteHelper.getUserSql();
    final resultPosts = await postRepository.getPosts(
      page: 0,
      size: 10,
      postSearchRequest: PostSearchRequest(status: PostStatus.APPROVED, userId: user?.id),
    );
    if (resultCategories.isSuccess && resultCategories.content != null) {
      final categories = List<Category>.from(resultCategories.content!);

      categories.add(Category(id: 0, name: 'Tất cả danh mục', avatar: AppImages.icon_all_categories, is_active: 1));

      emit(state.copyWith(categories: categories, categoriesLoading: false, categoriesError: null));
    }
    if (resultPosts.success && resultPosts.data != null) {
      emit(state.copyWith(posts: resultPosts.data!.content, postsPagination: resultPosts.data!.pagination, postsLoading: false, postsError: null));
    }
  }

  void onProductTap(BuildContext context, int index) {
    final item = state.posts[index];
    Navigator.pushNamed(
      context,
      AppRouterPaths.postDetailPage,
      arguments: {'item': item, 'loader': (int id) => postRepository.getPostDetailItem(id)},
    );
  }

  void changeTab(String tabName) {}

  void requestLocationPermission() {}

  void onCategoryTap(Category category) {}

  void onFavoriteTap(int index) {}
}
