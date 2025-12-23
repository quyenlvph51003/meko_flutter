import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/services/socket_service.dart';
import 'package:meko_project/models/body/chat/message_model.dart';
import 'package:meko_project/screens/chat_page/vm/chat_page_cubit.dart';
import 'package:meko_project/screens/chat_page/vm/chat_page_state.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class ChatPageScreen extends StatelessWidget {
  final String name;
  int? conversationId;
  final String avt;
  final int partner_id;
  ChatPageScreen({super.key, required this.name, this.conversationId, required this.avt, required this.partner_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(name)),
      body: BlocProvider(
        create: (context) => ChatPageCubit()..fetchMessages(conversationId ?? 0),
        child: ChatPage(name: name, conversationId: conversationId, avt: avt, partner_id: partner_id),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name;
  int? conversationId;
  final String avt;
  final int partner_id;
  ChatPage({super.key, required this.name, this.conversationId, required this.avt, required this.partner_id});

  @override
  State<ChatPage> createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPage> {
  late UserModel? user;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SocketService _socketService = SocketService();
  late StreamSubscription _sub;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    initSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  Future<void> getData() async {
    user = await SqliteHelper.getUserSql();
    print('duong ${widget.partner_id}');
  }

  Future<void> initSocket() async {
    _socketService.send({
      'event': 'join_conversation',
      'data': {
        'other_user_id': widget.partner_id, // TODO: truyền từ ngoài vào
      },
    });

    _sub = _socketService.messageController.listen((event) {
      final evt = event['event'];
      final data = event['data'];

      /// ACK join
      if (evt == 'join_conversation_ack') {
        final int newId = data['conversation_id'];
        setState(() {
          widget.conversationId = newId;
        });
        if (!mounted) return;
        // Sau khi có conversation_id, tải lịch sử tin nhắn (trường hợp từ detail post sang chưa có id)
        context.read<ChatPageCubit>().fetchMessages(newId);
        return;
      }

      /// New message
      if (evt == 'new_message' && data['conversation_id'] == widget.conversationId) {
        final msg = data['message'] as Map<String, dynamic>;
        if (!mounted) return;
        context.read<ChatPageCubit>().addIncoming(MessageChatModel.fromJson(msg));
      }
    });
  }

  @override
  void dispose() {
    // Gỡ listener để tránh leak khi rời màn hình
    _controller.dispose();
    _scrollController.dispose();
    _sub.cancel();
    super.dispose();
  }

  // final List<_Message> _messages = <_Message>[
  //   _Message(text: "Chào bạn! Mình có thể giúp gì?", isMe: false, time: "09:10"),
  //   _Message(text: "Sản phẩm này còn không ạ?", isMe: msg.senderId == user?.id, time: "09:11"),
  //   _Message(text: "Còn bạn nhé. Bạn muốn màu nào?", isMe: false, time: "09:12"),
  // ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _socketService.send({
      'event': 'send_message',
      'data': {
        'conversation_id': widget.conversationId, // null cũng OK
        'receiver_id': widget.partner_id, // otherUserId
        'type': 'text',
        'content': text,
      },
    });

    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _nowTime() {
    final now = TimeOfDay.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    print("sadosad ${h} ${m}");
    return "$h:$m";
  }

  String formatTimeFromServer(String? created, BuildContext context) {
    if (created == null || created.isEmpty) {
      return _nowTime();
    }

    final dateTime = DateTime.parse(created).toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final diffDays = today.difference(messageDay).inDays;

    // Hôm nay
    if (diffDays == 0) {
      return TimeOfDay.fromDateTime(dateTime).format(context);
    }

    // Hôm qua
    if (diffDays == 1) {
      return "Hôm qua ${TimeOfDay.fromDateTime(dateTime).format(context)}";
    }

    // Trước hôm qua
    return "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year} "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatPageCubit, ChatPageState>(
      builder: (context, state) {
        final showDemo = state.messages.isEmpty;
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(radius: 16, backgroundImage: widget.avt.isNotEmpty ? NetworkImage(widget.avt) : AssetImage(AppImages.img_avt_default)),
                const SizedBox(width: 12),
                Expanded(child: Text(widget.name, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          body: Column(
            children: [
              if (state.isLoading) const LinearProgressIndicator(minHeight: 2),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: showDemo ? state.messages.length : state.messages.length,
                  itemBuilder: (context, index) {
                    final radius = Radius.circular(16);
                    if (showDemo) {
                      final msg = state.messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: msg.senderId == user?.id ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (msg.senderId == user?.id)
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: widget.avt.isNotEmpty ? NetworkImage(widget.avt) : AssetImage(AppImages.img_avt_default),
                              ),
                            if (msg.senderId == user?.id) const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: msg.senderId == user?.id ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: msg.senderId == user?.id ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                                      borderRadius: BorderRadius.only(
                                        topLeft: radius,
                                        topRight: radius,
                                        bottomLeft: msg.senderId == user?.id ? radius : const Radius.circular(4),
                                        bottomRight: msg.senderId == user?.id ? const Radius.circular(4) : radius,
                                      ),
                                    ),
                                    child: Text(
                                      msg.content ?? '',
                                      style: TextStyle(color: msg.senderId == user?.id ? Colors.white : Colors.black87, fontSize: 15),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(msg.createdAt ?? '', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                ],
                              ),
                            ),
                            if (msg.senderId == user?.id) const SizedBox(width: 8),
                            if (msg.senderId == user?.id)
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: widget.avt.isNotEmpty ? NetworkImage(widget.avt) : AssetImage(AppImages.img_avt_default),
                              ),
                          ],
                        ),
                      );
                    } else {
                      final msg = state.messages[index];
                      final isMe = msg.senderId == user?.id; // TODO: replace with current user id
                      final created = msg.createdAt;
                      final time = created == null || created.isEmpty ? _nowTime() : formatTimeFromServer(created, context);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (!isMe)
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: widget.avt.isNotEmpty ? NetworkImage(widget.avt) : AssetImage(AppImages.img_avt_default),
                              ),
                            if (!isMe) const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                                      borderRadius: BorderRadius.only(
                                        topLeft: radius,
                                        topRight: radius,
                                        bottomLeft: isMe ? radius : const Radius.circular(4),
                                        bottomRight: isMe ? const Radius.circular(4) : radius,
                                      ),
                                    ),
                                    child: Text(msg.content ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 15)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(time, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                                ],
                              ),
                            ),
                            if (isMe) const SizedBox(width: 8),
                            if (isMe)
                              CircleAvatar(
                                radius: 14,
                                backgroundImage: (user?.avatar ?? '').isNotEmpty
                                    ? NetworkImage(user?.avatar ?? '')
                                    : AssetImage(AppImages.img_avt_default),
                              ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              _InputBar(
                controller: _controller,
                onSend: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;
                  // context.read<ChatPageCubit>().addIncoming(
                  //   MessageChatModel(content: text, createdAt: DateTime.now().toIso8601String(), senderId: user?.id),
                  // );
                  _sendMessage();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}, tooltip: 'Đính kèm'),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        minLines: 1,
                        maxLines: 4,
                        decoration: const InputDecoration(hintText: 'Nhập tin nhắn...', border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onSend,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(12), shape: const CircleBorder()),
              child: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isMe;
  final String time;

  _Message({required this.text, required this.isMe, required this.time});
}
