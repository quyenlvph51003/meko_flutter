// post_detail_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/body/review/reply_model.dart';
import 'package:meko_project/models/body/review/review_model.dart';
import 'package:meko_project/models/body/violation/violation_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/repository/report/report_repo.dart';
import 'package:meko_project/repository/reviews/review_repo.dart';
import 'package:meko_project/repository/rating/rating_repo.dart';
import 'package:meko_project/repository/violation/violation_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'post_detail_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final Future<ListingItem> Function(int) loader;
  final FavoriteRepo favoriteRepo;
  final ReviewRepo reviewRepo;
  final ViolationRepo violationRepo;
  final ReportRepo reportRepo;
  final RatingRepo ratingRepo;
  PostDetailCubit({
    required ListingItem item,
    required this.loader,
    required this.favoriteRepo,
    required this.reviewRepo,
    required this.violationRepo,
    required this.reportRepo,
    required this.ratingRepo,
  }) : super(
         PostDetailState(
           item: item,
           currentImageIndex: 0,
           isLiked: false,
           descriptionExpanded: false,
           reviews: [],
           commentController: TextEditingController(),
           autoFocus: true,
           isEdit: false,
           violations: [],
           myRating: null,
         ),
       );
  Future<void> init(int id) async {
    final itemPost = await loader(id);
    await fetchListReview(postId: id);
    emit(state.copyWith(item: itemPost, currentImageIndex: 0, isLiked: itemPost.isFavorite, myRating: itemPost.rating));
  }

  // rating
  Future<void> submitRating(double rating) async {
    final postId = state.item.id == 0 ? (state.item.postId ?? 0) : state.item.id;
    final ok = await ratingRepo.ratePost(postId: postId, rating: rating);
    if (ok) {
      emit(state.copyWith(myRating: rating));
      Fluttertoast.showToast(
        msg: 'Đã gửi đánh giá',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColor.cMain,
        textColor: Colors.white,
        fontSize: 16,
      );
    } else {
      Fluttertoast.showToast(msg: 'Gửi đánh giá thất bại');
    }
  }

  //createReview
  Future<void> createReview({required int postId, required String content}) async {
    await reviewRepo.createReview(postId: postId, content: content, parentId: state.reviewReply?.reviewId);
    await fetchListReview(postId: postId);
  }

  //deleteReview
  Future<void> deleteReview({required int reviewId}) async {
    await reviewRepo.deleteReview(reviewId: reviewId);
    await fetchListReview(postId: state.item.id);
  }

  //edit
  void changeEdit(bool isEdit) {
    emit(state.copyWithNullable(isEdit: isEdit));
  }

  //reply
  void changeReplyEdit(ReplyModel? reply) {
    emit(state.copyWithNullable(reply: reply, autoFocus: reply == null ? false : true, reviewReply: null));
  }

  Future<void> updateReview({required int reviewId, required String content}) async {
    await reviewRepo.upateReview(reviewId: reviewId, content: content);
    await fetchListReview(postId: state.item.id);
    emit(state.copyWith(isEdit: false));
  }

  //focus comment
  void changeAutoFocus(bool autoFocus) {
    emit(state.copyWith(autoFocus: autoFocus));
  }

  //reply comment
  void changeReviewReply(ReviewModel? review, {bool? isEdit}) {
    emit(state.copyWithNullable(reviewReply: review, autoFocus: review == null ? false : true, isEdit: isEdit ?? false));
  }

  void changeImageIndex(int index) {
    emit(state.copyWith(currentImageIndex: index));
  }

  void changeComment(String comment) {
    emit(state.copyWith(commentController: TextEditingController(text: comment)));
  }

  void toggleLike() {
    if (!state.isLiked) {
      fetchCreateFavorite();
    } else {
      fetchDeleteFavorite();
    }
    emit(state.copyWith(isLiked: !state.isLiked));
  }

  void toggleDescription() {
    emit(state.copyWith(descriptionExpanded: !state.descriptionExpanded));
  }

  //selected violation
  void changeViolationSelected(ViolationModel? violation) {
    emit(state.copyWithNullable(violationSelected: violation));
  }

  Future<void> fetchCreateFavorite() async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      return;
    }
    await favoriteRepo.createFavorite(postId: state.item.id, userId: user.id!);
  }

  //report

  Future<void> createReportCubit({required String content}) async {
    final response = await reportRepo.createReport(
      postId: state.item.id == 0 ? state.item.postId ?? 0 : state.item.id,
      violationId: state.violationSelected?.id ?? 0,
      reason: content,
    );
    if (response) {
      Fluttertoast.showToast(
        msg: "Bài viết đã được báo cáo",
        toastLength: Toast.LENGTH_SHORT, // hoặc Toast.LENGTH_LONG
        gravity: ToastGravity.BOTTOM, // vị trí hiển thị
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16,
      );
    }
  }

  // get list violation
  Future<void> fetchListViolation() async {
    final response = await violationRepo.getViolationList();
    if (response.data != null) {
      emit(state.copyWith(violations: response.data));
    }
  }

  Future<void> fetchDeleteFavorite() async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      return;
    }
    await favoriteRepo.deleteFavorite(postId: state.item.id, userId: user.id!);
  }

  //getReviews
  Future<void> fetchListReview({required int postId}) async {
    final response = await reviewRepo.getReviewList(postId: postId);
    if (response.data != null) {
      emit(state.copyWith(reviews: response.data));
    }
  }
}
