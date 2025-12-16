class ConversationModel {
  int? id;
  int? user1Id;
  int? user2Id;
  int? partnerId;
  String? partnerName;
  String? partnerAvatar;
  String? partnerEmail;
  String? lastMessage;
  String? lastMessageType;
  String? lastMessageAt;
  String? createdAt;
  int? unreadCount;

  ConversationModel(
      {this.id,
      this.user1Id,
      this.user2Id,
      this.partnerId,
      this.partnerName,
      this.partnerAvatar,
      this.partnerEmail,
      this.lastMessage,
      this.lastMessageType,
      this.lastMessageAt,
      this.createdAt,
      this.unreadCount});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user1Id = json['user1_id'];
    user2Id = json['user2_id'];
    partnerId = json['partner_id'];
    partnerName = json['partner_name'];
    partnerAvatar = json['partner_avatar'];
    partnerEmail = json['partner_email'];
    lastMessage = json['last_message'];
    lastMessageType = json['last_message_type'];
    lastMessageAt = json['last_message_at'];
    createdAt = json['created_at'];
    unreadCount = json['unread_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user1_id'] = this.user1Id;
    data['user2_id'] = this.user2Id;
    data['partner_id'] = this.partnerId;
    data['partner_name'] = this.partnerName;
    data['partner_avatar'] = this.partnerAvatar;
    data['partner_email'] = this.partnerEmail;
    data['last_message'] = this.lastMessage;
    data['last_message_type'] = this.lastMessageType;
    data['last_message_at'] = this.lastMessageAt;
    data['created_at'] = this.createdAt;
    data['unread_count'] = this.unreadCount;
    return data;
  }
}