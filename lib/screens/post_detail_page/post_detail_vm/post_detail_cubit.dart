// post_detail_cubit.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/body/review/reply_model.dart';
import 'package:meko_project/models/body/review/review_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/repository/reviews/review_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final Future<ListingItem> Function(int) loader;
  final FavoriteRepo favoriteRepo;
  final ReviewRepo reviewRepo;
  PostDetailCubit({required ListingItem item, required this.loader, required this.favoriteRepo, required this.reviewRepo})
    : super(
        PostDetailState(
          item: item,
          currentImageIndex: 0,
          isLiked: false,
          descriptionExpanded: false,
          reviews: [],
          commentController: TextEditingController(),
          autoFocus: true,
          isEdit: false,
        ),
      );
  Future<void> init(int id) async {
    final itemPost = await loader(id);
    await fetchListReview(postId: id);
    emit(state.copyWith(item: itemPost, currentImageIndex: 0, isLiked: itemPost.isFavorite));
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

  Future<void> fetchCreateFavorite() async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      return;
    }
    await favoriteRepo.createFavorite(postId: state.item.id, userId: user.id!);
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
