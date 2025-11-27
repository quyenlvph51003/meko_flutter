class MyReviewModel {
  int? reviewId;
  String? reviewComment;
  String? reviewCreatedAt;
  String? reviewUser;
  int? reviewUserId;
  String? reviewUserAvatar;
  int? postId;
  String? postTitle;
  String? postDesciption;
  String? price;
  String? postCreatedAt;
  String? postUpdatedAt;
  List<String>? imagesPost;
  List<String>? categoriesPost;

  MyReviewModel({
    this.reviewId,
    this.reviewComment,
    this.reviewCreatedAt,
    this.reviewUser,
    this.reviewUserId,
    this.reviewUserAvatar,
    this.postId,
    this.postTitle,
    this.postDesciption,
    this.price,
    this.postCreatedAt,
    this.postUpdatedAt,
    this.imagesPost,
    this.categoriesPost,
  });

  MyReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    reviewComment = json['review_comment']?.toString();
    reviewCreatedAt = json['review_created_at']?.toString();
    reviewUser = json['review_user']?.toString();
    reviewUserId = json['review_user_id'];
    reviewUserAvatar = json['review_user_avatar']?.toString();
    postId = json['post_id'];
    postTitle = json['post_title']?.toString();
    postDesciption = json['post_desciption']?.toString();
    price = json['price']?.toString();
    postCreatedAt = json['post_created_at']?.toString();
    postUpdatedAt = json['post_updated_at']?.toString();

    imagesPost = (json['images_post'] is List) ? List<String>.from(json['images_post'].map((e) => e.toString())) : [];

    categoriesPost = (json['categories_post'] is List) ? List<String>.from(json['categories_post'].map((e) => e.toString())) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['review_id'] = reviewId;
    data['review_comment'] = reviewComment;
    data['review_created_at'] = reviewCreatedAt;
    data['review_user'] = reviewUser;
    data['review_user_id'] = reviewUserId;
    data['review_user_avatar'] = reviewUserAvatar;
    data['post_id'] = postId;
    data['post_title'] = postTitle;
    data['post_desciption'] = postDesciption;
    data['price'] = price;
    data['post_created_at'] = postCreatedAt;
    data['post_updated_at'] = postUpdatedAt;
    data['images_post'] = imagesPost;
    data['categories_post'] = categoriesPost;
    return data;
  }
}
