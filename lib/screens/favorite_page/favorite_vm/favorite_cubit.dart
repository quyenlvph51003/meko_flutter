import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo favoriteRepo;
  FavoriteCubit({required this.favoriteRepo})
    : super(FavoriteState(listings: [], isLoading: false, isLoadMore: false, page: 0, size: 10, total: 0, isLastPage: false));

  void initCubit() async {
    emit(state.copyWith(isLoading: true));
    await getFavoriteList();
    emit(state.copyWith(isLoading: false));
  }

  void onProductTap(BuildContext context, int index, ListingItem item) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.postDetailPage,
      arguments: {'item': item, 'loader': (int id) => getIt<PostRepo>().getPostDetailItem(id)},
    );
  }

  Future<void> updateIsFavorite({required int index, required int postId}) async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      return;
    }

    if (state.isFavorite![index] == true) {
      final res = await favoriteRepo.deleteFavorite(userId: user.id!, postId: postId);
      if (res) {
        emit(state.copyWith(isFavorite: state.isFavorite!.map((key, value) => MapEntry(key, key == index ? false : value))));
      }
    } else {
      final res = await favoriteRepo.createFavorite(userId: user.id!, postId: postId);
      if (res) {
        emit(state.copyWith(isFavorite: state.isFavorite!.map((key, value) => MapEntry(key, key == index ? true : value))));
      }
    }
  }

  Future<void> loadMore() async {
    if (state.isLastPage || state.isLoadMore) {
      return;
    }
    emit(state.copyWith(isLoadMore: true));
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      emit(state.copyWith(isLoadMore: false));
      return;
    }
    final res = await favoriteRepo.getFavoriteList(userId: user.id!, page: state.page + 1);
    final newItems = res.data?.content ?? [];
    final isLast = newItems.length < 10 || newItems.isEmpty;
    final newMapFavorite = newItems.asMap().map((key, value) => MapEntry(key, true));
    final mergeMap = {...state.isFavorite!, ...newMapFavorite};
    emit(
      state.copyWith(listings: [...state.listings, ...newItems], page: state.page + 1, isLastPage: isLast, isLoadMore: false, isFavorite: mergeMap),
    );
  }

  Future<void> getFavoriteList() async {
    // reset to first page
    emit(state.copyWith(isLoading: true, page: 0, isLastPage: false));
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }
    final res = await favoriteRepo.getFavoriteList(userId: user.id!);
    final firstPageItems = res.data?.content ?? [];
    final isFavorite = firstPageItems.asMap().map((key, value) => MapEntry(key, true));
    emit(state.copyWith(listings: firstPageItems, isLastPage: false, isLoading: false, isFavorite: isFavorite));
  }
}
