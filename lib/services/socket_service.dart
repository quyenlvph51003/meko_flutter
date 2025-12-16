import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  WebSocketChannel? _channel;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageController => _messageController.stream;
  Future<void> connect() async {
    final authToken = await SqliteHelper.getAuthTokens();

    final uri = Uri.parse('wss://mekobe-production.up.railway.app/socket.io?token=${authToken?.token}');

    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      (data) {
        final json = jsonDecode(data);
        _messageController.add(json);
      },
      onError: (e) => print('❌ WS error: $e'),
      onDone: () => print('🔌 WS closed'),
    );

    print('🚀 WebSocket connecting...');
  }

  void send(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}
