import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/screens/chat_bot_handle/ai_data/ai_chat_api_client.dart';
import 'package:meko_project/screens/chat_bot_handle/ai_data/ai_chat_repository.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_vm/ai_chat_cubit.dart';
import 'chat_vm/ai_chat_state.dart';


class Env {
  static const String apiKey =
      '';
}

class MekoChatAiPage extends StatelessWidget {
  const MekoChatAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AiChatCubit>(
      create: (_) {
        final apiClient = AiChatApiClient(apiKey: Env.apiKey);
        final repo = AiChatRepository(apiClient: apiClient);
        return AiChatCubit(repository: repo);
      },
      child: const _MekoChatView(),
    );
  }
}

class _MekoChatView extends StatefulWidget {
  const _MekoChatView();

  @override
  State<_MekoChatView> createState() => _MekoChatViewState();
}

class _MekoChatViewState extends State<_MekoChatView> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void send() {
    final text = controller.text;
    if (text.trim().isEmpty) return;
    context.read<AiChatCubit>().sendMessage(text);
    controller.clear();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trợ lý AI Meko'), backgroundColor: AppColor.cMain, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AiChatCubit, AiChatState>(
              listenWhen: (prev, curr) => prev.messages.length != curr.messages.length,
              listener: (context, state) {
                _scrollToBottom();
              },
              builder: (context, state) {
                final messages = state.messages;
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppImages.icon_ai, width: 100, height: 100),
                        Text('Mình có thể giúp gì được cho bạn?', textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    final isMe = msg.isUser;
                    final align = isMe ? Alignment.centerRight : Alignment.centerLeft;
                    final bgColor = isMe ? AppColor.cMain : const Color(0xFFEFEFEF);
                    final textColor = isMe ? Colors.white : Colors.black87;

                    return Align(
                      alignment: align,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(msg.text, style: TextStyle(color: textColor)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: BlocBuilder<AiChatCubit, AiChatState>(
              builder: (context, state) {
                final isSending = state.isSending;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(hintText: 'Hỏi Meko AI...', border: InputBorder.none),
                          onSubmitted: (_) {
                            send();
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            backgroundColor: AppColor.cMain,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: isSending ? null : send,
                          child: isSending
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.send, size: 18),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
