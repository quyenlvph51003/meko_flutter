import 'package:meko_project/models/body/review/reply_model.dart';

class ReviewModel {
  int? reviewId;
  String? reviewComment;
  String? reviewCreatedAt;
  String? reviewUser;
  String? reviewUserAvatar;
  int? reviewUserId;
  List<ReplyModel>? replies;

  ReviewModel({this.reviewId, this.reviewComment, this.reviewCreatedAt, this.reviewUser, this.reviewUserAvatar, this.replies, this.reviewUserId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    reviewComment = json['review_comment'];
    reviewCreatedAt = json['review_created_at'];
    reviewUser = json['review_user'];
    reviewUserAvatar = json['review_user_avatar'];
    reviewUserId = json['review_user_id'];
    final rawReplies = json['replies'];

    if (rawReplies is List) {
      replies = rawReplies.where((e) => e is Map).map((e) => ReplyModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } else {
      replies = [];
    } // Nếu không phải List thì trả mảng rỗng
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_id'] = this.reviewId;
    data['review_comment'] = this.reviewComment;
    data['review_created_at'] = this.reviewCreatedAt;
    data['review_user'] = this.reviewUser;
    data['review_user_avatar'] = this.reviewUserAvatar;
    data['review_user_id'] = this.reviewUserId;
    data['replies'] = this.replies?.map((x) => x.toJson()).toList();
    return data;
  }
}
