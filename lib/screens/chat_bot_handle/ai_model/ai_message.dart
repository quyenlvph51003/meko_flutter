class AiMessage {
  final String id;
  final String text;
  final bool isUser;

  AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser,
    };
  }
}
