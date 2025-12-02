import 'package:meko_project/screens/chat_bot_handle/ai_model/ai_message.dart';

class AiChatState {
  final List<AiMessage> messages;
  final bool isSending;
  final String? error;

  AiChatState({required this.messages, required this.isSending, required this.error});

  factory AiChatState.initial() {
    return AiChatState(messages: const [], isSending: false, error: null);
  }

  AiChatState copyWith({List<AiMessage>? messages, bool? isSending, String? error}) {
    return AiChatState(messages: messages ?? this.messages, isSending: isSending ?? this.isSending, error: error);
  }
}
