import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/body/review/reply_model.dart';
import 'package:meko_project/models/body/review/review_model.dart';
import 'package:meko_project/models/body/violation/violation_model.dart';

class PostDetailState extends Equatable {
  final ListingItem item;
  final int currentImageIndex;
  final bool isLiked;
  final bool descriptionExpanded;
  final List<ReviewModel> reviews;
  final TextEditingController commentController;
  final bool? autoFocus;
  ReviewModel? reviewReply;
  ReplyModel? reply;
  final bool? isEdit;
  final List<ViolationModel> violations;
  ViolationModel? violationSelected;
  PostDetailState({
    required this.item,
    required this.currentImageIndex,
    required this.isLiked,
    required this.descriptionExpanded,
    required this.reviews,
    required this.commentController,
    required this.autoFocus,
    this.reviewReply,
    this.reply,
    this.isEdit,
    required this.violations,
    this.violationSelected,
  });

  PostDetailState copyWith({
    ListingItem? item,
    int? currentImageIndex,
    bool? isLiked,
    bool? descriptionExpanded,
    List<ReviewModel>? reviews,
    TextEditingController? commentController,
    bool? autoFocus,
    ReviewModel? reviewReply,
    ReplyModel? reply,
    bool? isEdit,
    List<ViolationModel>? violations,
    ViolationModel? violationSelected,
  }) {
    return PostDetailState(
      item: item ?? this.item,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      isLiked: isLiked ?? this.isLiked,
      descriptionExpanded: descriptionExpanded ?? this.descriptionExpanded,
      reviews: reviews ?? this.reviews,
      commentController: commentController ?? this.commentController,
      reviewReply: reviewReply ?? this.reviewReply,
      reply: reply ?? this.reply,
      autoFocus: autoFocus ?? this.autoFocus,
      isEdit: isEdit ?? this.isEdit,
      violations: violations ?? this.violations,
      violationSelected: violationSelected ?? this.violationSelected,
    );
  }

  PostDetailState copyWithNullable({
    ListingItem? item,
    int? currentImageIndex,
    bool? isLiked,
    bool? descriptionExpanded,
    List<ReviewModel>? reviews,
    TextEditingController? commentController,
    ReviewModel? reviewReply,
    ReplyModel? reply,
    bool? autoFocus,
    bool? isEdit,
    List<ViolationModel>? violations,
    ViolationModel? violationSelected,
  }) {
    return PostDetailState(
      item: item ?? this.item,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      isLiked: isLiked ?? this.isLiked,
      descriptionExpanded: descriptionExpanded ?? this.descriptionExpanded,
      reviews: reviews ?? this.reviews,
      commentController: commentController ?? this.commentController,
      autoFocus: autoFocus ?? this.autoFocus,
      reviewReply: reviewReply,
      reply: reply,
      isEdit: isEdit ?? this.isEdit,
      violations: violations ?? this.violations,
      violationSelected: violationSelected,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    item,
    currentImageIndex,
    isLiked,
    descriptionExpanded,
    reviews,
    commentController,
    autoFocus,
    reviewReply,
    reply,
    isEdit,
    violations,
    violationSelected,
  ];
}
