import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meko_project/screens/chat_bot_handle/ai_model/ai_message.dart';

class AiChatApiClient {
  final String apiKey;
  final http.Client httpClient;

  AiChatApiClient({required this.apiKey, http.Client? httpClient}) : httpClient = httpClient ?? http.Client();

  Future<String> sendMessage({required List<AiMessage> history, required String newMessage}) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final List<Map<String, String>> messages = [];

    messages.add({
      'role': 'system',
      'content':
          'Bạn là trợ lý AI của ứng dụng Meko – nền tảng mua sắm và trao đổi đồ cũ tại Việt Nam. '
          'Nhiệm vụ của bạn là hỗ trợ người dùng tìm sản phẩm, tư vấn giá, hướng dẫn mua bán an toàn, '
          'và giải thích thông tin liên quan đến đồ cũ. '
          'Yêu cầu trả lời: ngắn gọn, tự nhiên, dễ hiểu, thân thiện. '
          'Luôn trả lời bằng tiếng Việt. '
          'Bạn có thể hỗ trợ người dùng về: '
          '- Tìm kiếm sản phẩm đồ cũ (điện thoại, laptop, xe máy,..). '
          '- Gợi ý giá hợp lý, cách định giá sản phẩm. '
          '- Hướng dẫn đăng tin bán, mua hàng. '
          '- Cách kiểm tra sản phẩm trước khi mua. '
          '- Hiển thị ưu đãi, gian hàng nổi bật, sản phẩm mới đăng. '
          '- Hỗ trợ các vấn đề tài khoản, ví, giao dịch trong ứng dụng Meko. '
          'Luôn giữ thái độ lịch sự, thân thiện và hữu ích.',
    });
    for (final m in history) {
      messages.add({'role': m.isUser ? 'user' : 'assistant', 'content': m.text});
    }

    messages.add({'role': 'user', 'content': newMessage});

    final body = {'model': 'gpt-4.1-mini', 'messages': messages, 'temperature': 0.7};

    final res = await httpClient.post(url, headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $apiKey'}, body: jsonEncode(body));

    if (res.statusCode != 200) {
      throw Exception('AI API error: ${res.statusCode} - ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('AI API response invalid (no choices)');
    }

    final message = choices[0]['message'] as Map<String, dynamic>?;
    if (message == null) {
      throw Exception('AI API response invalid (no message)');
    }

    final reply = message['content'] as String?;
    if (reply == null || reply.isEmpty) {
      throw Exception('AI API response invalid (empty content)');
    }

    return reply;
  }
}
