import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/post/post_repo.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final PostRepo postRepo;
  CategoriesCubit({required this.postRepo}) : super(CategoriesState(listings: [], isLoading: false, rebuild: 0));

  Future<void> init({required int categoryId}) async {
    await getCategories(categoryIds: [categoryId], page: 0, size: 10);
  }

  Future<void> getCategories({
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
