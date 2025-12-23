import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/screens/chat_page/chat_page_screen.dart';
import 'package:meko_project/screens/tab/tab_chat/tab_chat_vm/tab_chat_cubit.dart';
import 'package:meko_project/screens/tab/tab_chat/tab_chat_vm/tab_chat_state.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class TabChatPage extends StatefulWidget {
  const TabChatPage({super.key});

  @override
  State<TabChatPage> createState() => _TabChatPageState();
}

class _TabChatPageState extends State<TabChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tin nhắn"), centerTitle: true),
      body: BlocProvider(
        create: (context) => TabChatCubit()..init(),
        child: BlocBuilder<TabChatCubit, TabChatState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: AppLoader());
            }

            if (state.conversations.isEmpty) {
              return const Center(child: Text('Chưa có cuộc trò chuyện'));
            }
            return RefreshIndicator(
              onRefresh: () => context.read<TabChatCubit>().init(),
              child: ListView.separated(
                itemCount: state.conversations.length,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemBuilder: (context, index) {
                  final conversation = state.conversations[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPageScreen(
                            name: conversation.partnerName ?? '',
                            conversationId: conversation.id ?? 0,
                            avt: conversation.partnerAvatar ?? '',
                            partner_id: conversation.partnerId ?? 0,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: (conversation.partnerAvatar != null && (conversation.partnerAvatar?.isNotEmpty ?? false))
                              ? NetworkImage(conversation.partnerAvatar!)
                              : AssetImage(AppImages.img_avt_default) as ImageProvider,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      conversation?.partnerName ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    timeAgo(DateTime.tryParse(conversation?.createdAt ?? '') ?? DateTime.now()),
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(conversation?.lastMessage ?? 'Hãy bắt đầu trò chuyện...', maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                  // return ListTile(
                  //   leading: CircleAvatar(
                  //     radius: 26,
                  //     backgroundImage: conversation?.partnerAvatar == null
                  //         ? NetworkImage(conversation?.partnerAvatar ?? '')
                  //         : Image.asset(AppImages.img_avt_default).image,
                  //   ),
                  //   title: Text(conversation?.partnerName ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  //   subtitle: Text(conversation?.lastMessage ?? 'Hãy bắt đầu trò chuyện...', maxLines: 1, overflow: TextOverflow.ellipsis),
                  //   trailing: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         timeAgo(DateTime.tryParse(conversation?.createdAt ?? '') ?? DateTime.now()),
                  //         style: const TextStyle(color: Colors.grey, fontSize: 12),
                  //       ),
                  //       const SizedBox(height: 4),
                  //       if ((conversation?.unreadCount ?? 0) > 0)
                  //         Container(
                  //           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  //           decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                  //           child: Text("${conversation?.unreadCount}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  //         ),
                  //     ],
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPageScreen(name: conversation?.partnerName ?? '')));
                  //   },
                  // );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) {
    return 'vừa xong';
  }

  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} phút trước';
  }

  if (diff.inHours < 24) {
    return '${diff.inHours} giờ trước';
  }

  if (diff.inDays == 1) {
    return 'hôm qua';
  }

  if (diff.inDays < 7) {
    return '${diff.inDays} ngày trước';
  }

  return '${_twoDigits(dateTime.day)}/${_twoDigits(dateTime.month)}/${dateTime.year}';
}

String _twoDigits(int n) => n.toString().padLeft(2, '0');
