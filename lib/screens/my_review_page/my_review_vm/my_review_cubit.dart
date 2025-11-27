import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/body/review/my_review_model.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/repository/reviews/review_repo.dart' show ReviewRepo;
import 'package:meko_project/routers/app_router_paths.dart';

part 'my_review_state.dart';

class MyReviewCubit extends Cubit<MyReviewState> {
  final ReviewRepo reviewRepo;
  final PostRepo postRepo;

  MyReviewCubit({required this.reviewRepo, required this.postRepo})
    : super(const MyReviewState(tabIndex: 0, listReview: [], isLoading: false, page: 0, hasMore: true));

  /// Khởi tạo cubit, load page đầu tiên
  Future<void> initCubit() async {
    await getReviews(page: 0, isRefresh: true);
  }

  void onProductTap(BuildContext context, int index) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.postDetailPage,
      arguments: {
        'item': ListingItem(
          id: state.listReview[index].postId ?? 0,
          userPostId: state.listReview[index].reviewUserId ?? 0,
          userNamePoster: state.listReview[index].reviewUser ?? '',
          avatarPoster: state.listReview[index].reviewUserAvatar ?? '',
          title: state.listReview[index].postTitle ?? '',
          emailPoster: '',
          description: '',
          price: '',
          address: '',
          status: '',
          phoneNumber: '',
          expiredAt: null,
          isPinned: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          wardCode: '',
          provinceCode: '',
          images: [],
          categories: [],
        ),
        'loader': (int id) => postRepo.getPostDetailItem(id),
      },
    );
  }

  /// Lấy danh sách đánh giá, isRefresh = true để reset list
  Future<void> getReviews({required int page, bool isRefresh = false}) async {
    // Tránh gọi khi đang loading hoặc hết page
    if (state.isLoading || (!state.hasMore && !isRefresh)) return;

    emit(state.copyWith(isLoading: true));

    try {
      final response = await reviewRepo.getReviewListByUser(page: page, size: 10, tabIndex: state.tabIndex);

      if (response.success) {
        final newList = response.data?.content ?? [];
        final updatedList = isRefresh ? newList : [...state.listReview, ...newList];

        // Kiểm tra còn page tiếp theo
        final pagination = response.data?.pagination;
        final hasMore = pagination != null ? (pagination.currentPage < (pagination.totalPages - 1)) : false;

        emit(state.copyWith(listReview: updatedList, isLoading: false, page: page, hasMore: hasMore));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e, s) {
      // Debug: in ra lỗi + stacktrace
      print('Error getReviews: $e');
      print(s);
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Đổi tab: reset list, reset page, load page đầu tiên
  void changeTabIndex(int tabIndex) {
    emit(state.copyWith(tabIndex: tabIndex, listReview: [], page: 0, hasMore: true));
    getReviews(page: 0, isRefresh: true);
  }

  /// Load thêm page tiếp theo
  void loadMore() {
    if (state.hasMore && !state.isLoading) {
      getReviews(page: state.page + 1);
    }
  }
}
