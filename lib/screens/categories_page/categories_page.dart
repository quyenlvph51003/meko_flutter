import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/screens/categories_page/categories_cubit/categories_vm.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:meko_project/widget/product/product_card.dart';
import 'package:meko_project/widget/widget_helper.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key, required this.caytegoryId, required this.categoryName}) : super(key: key);
  final int caytegoryId;
  final String categoryName;
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesCubit(postRepo: getIt<PostRepo>())..init(categoryId: widget.caytegoryId),
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          final vm = context.read<CategoriesCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 50),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(24), bottomLeft: Radius.circular(24)),
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)]),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          WidgetHelper.backArrow(context),
                          const SizedBox(height: 24),
                          Text(
                            widget.categoryName,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          const Text('Mua thì hời, bán thì lời', style: TextStyle(fontSize: 14, color: Colors.white)),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -50),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: const Offset(1, 2), blurRadius: 4)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Image.asset(AppImages.icon_location, width: 24, height: 24, color: AppColor.cMain),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Khu vực:',
                                    style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _showBottomFilter(context);
                                      },
                                      child: Text(
                                        'Tất cả khu vực',
                                        style: TextStyle(fontSize: 16, color: AppColor.cMain, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.search, color: Colors.grey),
                                            const SizedBox(width: 8),
                                            Text('Tìm danh mục...', style: TextStyle(fontSize: 15, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              AppButton(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Text('Tìm', style: TextStyle(fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text('Danh sách bài viết', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  _buildPosts(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPosts(CategoriesState state) {
    if (state.isLoading) {
      return const AppLoader();
    }
    if (state.listings.isEmpty) {
      return WidgetHelper.noDataListing();
    }
    return Transform.translate(
      offset: const Offset(0, -35),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  // mainAxisSpacing: 12,
                ),
                itemCount: state.listings.length,
                itemBuilder: (context, index) {
                  // final item = state.posts[index];
                  return ProductCart(
                    item: state.listings[index],
                    index: index,
                    onTap: () {
                      // vm.onProductTap(context, index);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showBottomFilter(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true, // tap ra ngoài để đóng
      backgroundColor: Colors.white, // màu background của bottom sheet
      barrierColor: Colors.black.withOpacity(0.5), // làm mờ màn hình
      context: context,
      builder: (ctx) {
        return Container(
          height: 270,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: Icon(Icons.cancel, size: 25, color: Colors.black),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Khu vực', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.withValues(alpha: 0.5), thickness: 1, endIndent: 0),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showBottomFilterLocation(ctx);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tỉnh, thành phố *',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                  Text('Chọn tỉnh, thành phố', style: TextStyle(fontSize: 14, color: Colors.black)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        _showBottomFilterLocation(ctx);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Xã, phường *',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                                  ),
                                  Text('Chọn xã, phường', style: TextStyle(fontSize: 14, color: Colors.black)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey, size: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Xoá lọc', style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: AppButton(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 9),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Áp dụng', style: TextStyle(color: Colors.white)),
                              ),
                            ),
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
      },
    );
  }

  void _showBottomFilterLocation(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true, // tap ra ngoài để đóng
      backgroundColor: Colors.white, // màu background của bottom sheet
      barrierColor: Colors.black.withOpacity(0.5), // làm mờ màn hình
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: Icon(Icons.cancel, size: 25, color: Colors.black),
                      ),
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Tỉnh thành', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.withValues(alpha: 0.5), thickness: 1, endIndent: 0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (cont, index) {
                      return RadioListTile(value: index, groupValue: 1, onChanged: (value) {}, title: Text('Item $index'));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
