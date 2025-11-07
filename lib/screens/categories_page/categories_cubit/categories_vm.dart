import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/location/province_repo.dart';
import 'package:meko_project/repository/location/ward_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/widget/product/product_card_search.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final PostRepo postRepo;
  final WardRepo wardRepo;
  final ProvinceRepo provinceRepo;
  final CategoryRepository categoryRepo;
  CategoriesCubit({required this.postRepo, required this.wardRepo, required this.provinceRepo, required this.categoryRepo})
    : super(CategoriesState(listings: [], isLoading: false, rebuild: 0, provinces: [], wards: [], categories: []));

  Future<void> init({required int categoryId}) async {
    await getPostByFilter(categoryIds: categoryId != 0 ? [categoryId] : null, page: 0, size: 10);
  }

  void selectedProvinceCubit(ProvinceModel province) {
    emit(state.copyWithNullable(selectedProvince: province, rebuild: state.rebuild + 1));
  }

  void selectedWardCubit(WardModel ward) {
    emit(state.copyWithNullable(selectedWard: ward, rebuild: state.rebuild + 1, selectedProvince: state.selectedProvince));
  }

  void resetSelected() {
    emit(state.copyWithNullable(selectedProvince: null, selectedWard: null, rebuild: state.rebuild + 1));
  }

  void selectedCategoryCubit(Category category) {
    emit(state.copyWith(selectedCategory: category, rebuild: state.rebuild + 1));
  }

  void onProductTap(BuildContext context, int index, ListingItem item) {
    Navigator.pushNamed(context, AppRouterPaths.postDetailPage, arguments: {'item': item, 'loader': (int id) => postRepo.getPostDetailItem(id)});
  }

  void onSearchProductTap(BuildContext context, int categoryId) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.searchPage,
      arguments: {
        'onSearch': (String query) async {
          final result = await postRepo.getPosts(
            page: 0,
            size: 10,
            postSearchRequest: PostSearchRequest(searchText: query, status: PostStatus.APPROVED, categoryIds: categoryId != 0 ? [categoryId] : null),
          );
          return result.data?.content ?? [];
        },
        'itemBuilder': (dynamic item) {
          return ItemProductSearch(
            imageUrl: item.images.isNotEmpty ? item.images.first : '',
            title: item.title,
            description: item.address,
            price: double.tryParse(item.price) ?? 0,
            onTap: () => onProductTap(context, 0, item),
          );
        },
        'onSelected': (dynamic item) {
          onProductTap(context, 0, item);
        },
        'hintText': 'Tìm kiếm bài viết...',
      },
    );
  }

  Future<void> fetchFilter({required int categoryId}) async {
    await getPostByFilter(
      categoryIds: (state.selectedCategory?.id == 0)
          ? null
          : (state.selectedCategory != null)
          ? [state.selectedCategory!.id]
          : categoryId != 0
          ? [categoryId]
          : null,
      provinceCode: state.selectedProvince?.code,
      wardCode: state.selectedWard?.code,
      page: 0,
      size: 10,
    );
  }

  void filterStrAddress() {
    if (state.selectedProvince != null) {
      //phường mà null thì không có dấu phẩy
      emit(
        state.copyWith(
          addressFilter: '${state.selectedWard != null ? '${state.selectedWard?.name}, ' : ''} ${state.selectedProvince?.name}',
          rebuild: state.rebuild + 1,
        ),
      );
    }
  }

  Future<void> getCategories() async {
    try {
      final result = await categoryRepo.getAllCategory();
      if (result.isSuccess) {
        final categories = [Category(id: 0, name: 'Tất cả danh mục', avatar: '', is_active: 1)];
        categories.addAll(List<Category>.from(result.content ?? []));
        emit(state.copyWith(categories: categories, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      print(e);
    }
  }

  /// fetch api
  Future<void> getProvinces() async {
    try {
      final result = await provinceRepo.getProvinces();
      if (result.isSuccess) {
        emit(state.copyWith(provinces: result.data, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getWards(String provinceCodeId) async {
    try {
      final result = await wardRepo.getWards(provinceCodeId: provinceCodeId);
      if (result.isSuccess) {
        emit(state.copyWith(wards: result.data, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getPostByFilter({
    List<int>? categoryIds,
    String? provinceCode,
    String? wardCode,
    String? searchText,
    required int page,
    required int size,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      PostSearchRequest request = PostSearchRequest(
        provinceCode: provinceCode,
        wardCode: wardCode,
        searchText: searchText,
        categoryIds: categoryIds,
        status: PostStatus.APPROVED,
      );
      final result = await postRepo.getPosts(page: page, size: size, postSearchRequest: request);
      if (result.isSuccess) {
        emit(state.copyWith(listings: result.data?.content ?? [], isLoading: false));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
