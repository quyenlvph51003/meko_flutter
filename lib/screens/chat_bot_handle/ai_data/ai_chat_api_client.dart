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
          'Các danh mục sản phẩm hiện có trong ứng dụng Meko gồm: '
          '- Điện thoại & Đồ điện tử '
          '- Xe cộ '
          '- Thời trang '
          '- Trang sức '
          '- Sách, văn phòng phẩm '
          '- Đồ gia dụng & Nội thất '
          '- Mẹ & Bé '
          '- Phụ kiện thú cưng '
          '- Thể thao & Giải trí. '
          'Bạn có thể hỗ trợ người dùng về: '
          '- Tìm kiếm sản phẩm đồ cũ theo danh mục. '
          '- Gợi ý giá hợp lý, cách định giá sản phẩm. '
          '- Hướng dẫn đăng tin bán và mua hàng. '
          '- Cách kiểm tra sản phẩm trước khi mua để tránh rủi ro. '
          '- Giới thiệu ưu đãi, gian hàng nổi bật, sản phẩm mới đăng. '
          '- Hỗ trợ các vấn đề liên quan đến tài khoản, ví và giao dịch trong ứng dụng Meko. '
          'Quy trình giao hàng trong ứng dụng Meko như sau: '
          '- Người mua đặt đơn hàng. '
          '- Người bán duyệt hoặc từ chối đơn hàng. '
          '- Sau khi người bán duyệt, đơn hàng được chuyển sang đơn vị vận chuyển bên thứ ba. '
          '- Đơn vị vận chuyển bên thứ ba chịu trách nhiệm lấy hàng, giao hàng và cập nhật trạng thái đơn hàng. '
          '- Trạng thái đơn hàng sẽ được đồng bộ và hiển thị cho cả người mua và người bán trong ứng dụng Meko. '
          'Khi người dùng hỏi về giao hàng, trạng thái đơn, phí vận chuyển hoặc thời gian nhận hàng, '
          'hãy giải thích ngắn gọn theo đúng quy trình trên. '
          'Nếu đơn hàng đang được vận chuyển, hãy hướng dẫn người dùng theo dõi trạng thái trong mục "Đơn hàng". '
          'Nếu có sự cố giao hàng, hãy khuyên người dùng liên hệ hỗ trợ hoặc chờ cập nhật từ đơn vị vận chuyển bên thứ ba. '
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
