import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/chat/conversation_model.dart';
import 'package:meko_project/models/body/chat/message_model.dart';
import 'package:meko_project/models/response_common.dart';

class ChatRepository {
  final RestClient restClient;
  ChatRepository({required this.restClient});

  Future<ResponseCommon<List<MessageChatModel>>> getlistMessages(int conversationId) async {
    try {
      final response = await restClient.get('chat/messages', queryParameters: {'conversation_id': conversationId, "page": 1, "limit": 200});
      return ResponseCommon<List<MessageChatModel>>.fromJson(
        response.data,
        (data) => (data['messages'] as List).map((e) => MessageChatModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return ResponseCommon<List<MessageChatModel>>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: const [],
        success: false,
      );
    }
  }

  Future<ResponseCommon<List<ConversationModel>>> getConversations() async {
    try {
      final response = await restClient.get('chat/conversations');
      return ResponseCommon<List<ConversationModel>>.fromJson(
        response.data,
        (data) => (data as List).map((e) => ConversationModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return ResponseCommon<List<ConversationModel>>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: const [],
        success: false,
      );
    }
  }
}
