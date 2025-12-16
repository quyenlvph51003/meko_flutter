class MessageChatModel {
  int? id;
  int? conversationId;
  int? senderId;
  String? type;
  String? content;
  int? isRead;
  String? createdAt;
  // List<String>? attachments;

  MessageChatModel({this.id, this.conversationId, this.senderId, this.type, this.content, this.isRead, this.createdAt});

  MessageChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    type = json['type'];
    content = json['content'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['type'] = this.type;
    data['content'] = this.content;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    return data;
  }
}
