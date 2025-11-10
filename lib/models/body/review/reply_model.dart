class ReplyModel {
  int? replyId;
  String? replyUser;
  String? replyComment;
  String? replyCreatedAt;
  String? replyUserAvatar;
  int? replyUserId;
  ReplyModel({this.replyId, this.replyUser, this.replyComment, this.replyCreatedAt, this.replyUserAvatar, this.replyUserId});

  ReplyModel.fromJson(Map<String, dynamic> json) {
    replyId = json['reply_id'];
    replyUser = json['reply_user'];
    replyComment = json['reply_comment'];
    replyCreatedAt = json['reply_created_at'];
    replyUserAvatar = json['reply_user_avatar'];
    replyUserId = json['reply_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reply_id'] = this.replyId;
    data['reply_user'] = this.replyUser;
    data['reply_comment'] = this.replyComment;
    data['reply_created_at'] = this.replyCreatedAt;
    data['reply_user_avatar'] = this.replyUserAvatar;
    data['reply_user_id'] = this.replyUserId;
    return data;
  }
}
