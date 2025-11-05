import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/consts/app_paths.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/global_data/data_local/hive_db.dart';
import 'package:meko_project/global_data/data_local/sql_maneger.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/screens/tab/tab_home/tab_home_vm/tab_home_cubit.dart';
import 'package:meko_project/screens/tab/tab_home/tab_home_vm/tab_home_state.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class TabHomePage extends StatelessWidget {
  const TabHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabHomeCubit(
        categoryRepository: getIt<CategoryRepository>(),
        postRepository: getIt<PostRepo>(),
      ),
      child: const _TabHomeView(),
    );
  }
}

class _TabHomeView extends StatefulWidget {
  const _TabHomeView({Key? key}) : super(key: key);

  @override
  State<_TabHomeView> createState() => _TabHomeViewState();
}

class _TabHomeViewState extends State<_TabHomeView> {
  late ScrollController scrollController;
  late TabHomeCubit vm;

  @override
  void initState() {
    super.initState();
    vm = context.read<TabHomeCubit>();
    scrollController = ScrollController();
    vm.fetchCategories();
    vm.fetchPosts(page: 0);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const overlap = 20.0;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          ),
        ),
        child: RefreshLoadmore(
          isLastPage: vm.state.noMore ?? false,
          noMoreWidget: const Center(child: Text('Không có bài viết')),
          loadingWidget: const AppLoader(),
          onRefresh: () async {
            vm.onRefresh();
          },
          onLoadmore: () async {
            if (vm.state.noMore == true) return;
            final page = vm.state.page ?? 0;
            vm.fetchPosts(page: page + 1, isLoadMore: true);
          },
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                          ),
                        ),
                        child: Column(
                          children: [
                            SafeArea(
                              top: true,
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            buildHeaderSection(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, -overlap),
                        child: GestureDetector(
                          onTap: () {
                            print('sdfsdfsd');
                          },
                          child: buildSearchBar(),
                        ),
                      ),
                      const SizedBox(height: overlap),
                    ],
                  ),
                  buildCategoryGrid(),
                  SizedBox(height: 16),
                  Container(
                    width: AppDimens.getWidth(context),
                    height: 10,
                    color: AppColor.cGray70,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 16),
                      Text(
                        'Danh sách bài viết',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.cBlack,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  buildListItemPost(),
                  SizedBox(height: bottomPadding + 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListItemPost() {
    return BlocBuilder<TabHomeCubit, TabHomeState>(
      buildWhen: (p, c) {
        return p.postsLoading != c.postsLoading ||
            p.posts != c.posts ||
            p.postsError != c.postsError;
      },
      builder: (context, state) {
        if (state.postsLoading) {
          return const AppLoader();
        }
        if (state.postsError != null) {
          return Center(
            child: Text(
              'Lỗi tải bài viết',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.63,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              final item = state.posts[index];
              return buildProductCard(context, item, index);
            },
          ),
        );
      },
    );
  }

  Widget buildProductCard(BuildContext context, ListingItem item, int index) {
    return GestureDetector(
      onTap: () {
        vm.onProductTap(context, index);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppDimens.getHeight(context) * 0.17,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      item.images.isNotEmpty
                          ? item.images.first
                          : AppPaths.img_splash,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 32),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      vm.onFavoriteTap(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.status, // ví dụ "APPROVED"
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price} đ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final userProfile = await SqliteHelper.getUserSql();
                },
                child: Text(
                  'Bạn muốn mua gì?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Mua thì hời, bán thì lời',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return GestureDetector(
      onTap: () {
        vm.onSearchTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 12,
            left: 4,
            right: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              AppButton(
                onTap: () {
                  showCategorySheet(context);
                },
                child: Text(
                  'Danh mục',
                  style: TextStyle(
                    color: AppColor.cBlack,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: 2),
              Container(
                width: 11,
                height: 10,
                child: Image.asset(AppPaths.ic_drop_down),
              ),
              SizedBox(width: 10),
              Container(width: 0.5, height: 15, color: AppColor.cGray),
              SizedBox(width: 25),
              Expanded(
                child: Text(
                  'Tìm kiếm..',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              SizedBox(width: 3),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.cMain,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4),
                child: Icon(Icons.search, color: AppColor.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryGrid() {
    return BlocBuilder<TabHomeCubit, TabHomeState>(
      buildWhen: (previous, current) {
        return previous.categoriesLoading != current.categoriesLoading ||
            previous.categories != current.categories ||
            previous.categoriesError != current.categoriesError;
      },
      builder: (context, state) {
        if (state.categoriesLoading) {
          return const AppLoader();
        }
        if (state.categoriesError != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Column(
                children: [
                  Text('Lỗi tải danh mục', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      vm.fetchCategories();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox(
          height: 250,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 hàng
              childAspectRatio: 1, // điều chỉnh tỉ lệ item (1 là vuông)
              mainAxisSpacing: 5, // khoảng cách ngang
              crossAxisSpacing: 10,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return buildCategoryItem(category, category.id);
            },
          ),
        );
      },
    );
  }

  Widget buildCategoryItem(dynamic category, int categoryId) {
    return GestureDetector(
      onTap: () {
        // vm.onCategoryTap(category);
        print('dasdsdfsdfsd');
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 70,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                    ),
                    (categoryId != 0)
                        ? Image.network(
                            category.avatar ?? '',
                            fit: BoxFit.cover,
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 32,
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: AppLoader(size: 20));
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(14),
                            child: Image.asset(
                              AppImages.icon_all_categories,
                              width: 15,
                              height: 15,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  category.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).padding.bottom;
        return BlocProvider.value(
          value: vm,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Danh mục',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  // Danh sách tên danh mục: category.name ?? ''
                  Flexible(
                    child: BlocBuilder<TabHomeCubit, TabHomeState>(
                      builder: (context, state) {
                        // Loading / lỗi: giữ nguyên logic bên ngoài, ở đây chỉ hiển thị danh sách có sẵn
                        final items = state.categories;
                        if (items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('Chưa có danh mục'),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final category = items[index];
                            return ListTile(
                              dense: true,
                              title: Text(
                                category.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                // Giữ nguyên logic hiện tại (chưa dùng onCategoryTap)
                                // Nếu sau này bạn muốn chọn danh mục để lọc, thêm gọi vm.onCategoryTap(category) ở đây
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget buildProductCard(BuildContext context, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       // vm.onProductTap(index);
  //       print('Click item post');
  //     },
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           height: AppDimens.getHeight(context)*0.17,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.all(Radius.circular(8)),
  //           ),
  //           child: Stack(
  //             children: [
  //               Positioned.fill(
  //                 child: Image.asset(
  //                   AppPaths.img_splash,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               Positioned(
  //                 top: 8,
  //                 right: 8,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     vm.onFavoriteTap(index);
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.all(4),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white.withOpacity(0.9),
  //                       shape: BoxShape.circle,
  //                     ),
  //                     child: const Icon(
  //                       Icons.favorite_border,
  //                       size: 16,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // Tiêu đề (tối đa 2 dòng)
  //               Text(
  //                 'CẦN PASS LẠI BÀN LÀM VIỆC LỚN',
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: const TextStyle(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w600,
  //                   color: Color(0xFF111111),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 2),
  //
  //               // Trạng thái / mô tả ngắn (nhỏ, màu xám)
  //               Text(
  //                 'Mới',
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                   fontSize: 11,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 4),
  //
  //               // Giá (đỏ, đậm)
  //               Text(
  //                 '3.300.000 đ',
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: const TextStyle(
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w700,
  //                   color: Color(0xFFE53935), // đỏ giống mẫu
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 4),
  //
  //               // Địa điểm (icon + text xám, 1 dòng)
  //               Row(
  //                 children: [
  //                   Icon(
  //                     Icons.location_on_outlined,
  //                     size: 12,
  //                     color: Colors.grey[600],
  //                   ),
  //                   const SizedBox(width: 4),
  //                   Expanded(
  //                     child: Text(
  //                       'Tp Hồ Chí Minh',
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                         fontSize: 11,
  //                         color: Colors.grey[600],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         )
  //
  //       ],
  //     ),
  //   );
  // }
}
