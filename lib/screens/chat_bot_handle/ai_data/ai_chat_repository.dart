import 'package:meko_project/screens/chat_bot_handle/ai_model/ai_message.dart';

import 'ai_chat_api_client.dart';

class AiChatRepository {
  final AiChatApiClient apiClient;

  AiChatRepository({required this.apiClient});

  Future<String> sendMessage({required List<AiMessage> history, required String newMessage}) {
    return apiClient.sendMessage(history: history, newMessage: newMessage);
  }
}
