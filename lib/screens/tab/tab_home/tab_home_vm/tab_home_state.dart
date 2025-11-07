import 'package:equatable/equatable.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/paginated_result_common.dart';

class TabHomeState extends Equatable {
  final String selectedTab;
  final bool isAppBarCollapsed;

  // Danh mục
  final List<Category> categories;
  final bool categoriesLoading;
  final String? categoriesError;
  Category? selectedCategory;

  // Bài viết
  final List<ListingItem> posts;
  final bool postsLoading;
  final String? postsError;
  final Pagination? postsPagination;
  final int? page;
  final bool? noMore;
  final int productCount;

  TabHomeState({
    required this.selectedTab,
    required this.isAppBarCollapsed,
    required this.categories,
    required this.categoriesLoading,
    this.categoriesError,
    required this.posts,
    required this.postsLoading,
    this.postsError,
    this.postsPagination,
    this.page,
    this.noMore,
    required this.productCount,
    this.selectedCategory,
  });

  factory TabHomeState.initial() {
    return TabHomeState(
      selectedTab: 'Dành cho bạn',
      isAppBarCollapsed: false,
      categories: [],
      categoriesLoading: true,
      categoriesError: null,
      posts: [],
      postsLoading: false,
      postsError: null,
      postsPagination: null,
      page: 0,
      productCount: 0,
    );
  }

  TabHomeState copyWith({
    String? selectedTab,
    bool? isAppBarCollapsed,
    List<Category>? categories,
    bool? categoriesLoading,
    String? categoriesError,
    List<ListingItem>? posts,
    bool? postsLoading,
    String? postsError,
    Pagination? postsPagination,
    int? page,
    bool? noMore,
    int? productCount,
    Category? selectedCategory,
  }) {
    return TabHomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      isAppBarCollapsed: isAppBarCollapsed ?? this.isAppBarCollapsed,
      categories: categories ?? this.categories,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      categoriesError: categoriesError ?? this.categoriesError,
      posts: posts ?? this.posts,
      postsLoading: postsLoading ?? this.postsLoading,
      postsError: postsError ?? this.postsError,
      postsPagination: postsPagination ?? this.postsPagination,
      page: page ?? this.page,
      noMore: noMore ?? this.noMore,
      productCount: productCount ?? this.productCount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    selectedTab,
    isAppBarCollapsed,
    categories,
    categoriesLoading,
    categoriesError,
    posts,
    postsLoading,
    postsError,
    postsPagination,
    page,
    noMore,
    productCount,
    selectedCategory,
  ];
}
