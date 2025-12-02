import 'package:flutter/material.dart';

class TabChatPage extends StatelessWidget {
  const TabChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<UserChatItem> users = [
      UserChatItem(
        name: "Nguyễn Văn A",
        avatar: "https://i.pravatar.cc/150?img=1",
        lastMessage: "Anh ơi sản phẩm này còn không?",
        time: "09:12",
        unread: 2,
      ),
      UserChatItem(name: "Trần Thị B", avatar: "https://i.pravatar.cc/150?img=2", lastMessage: "Dạ em cảm ơn anh!", time: "08:45", unread: 0),
      UserChatItem(
        name: "Tuấn Shop",
        avatar: "https://i.pravatar.cc/150?img=3",
        lastMessage: "Đơn hàng của bạn đã được xác nhận.",
        time: "Hôm qua",
        unread: 1,
      ),
      UserChatItem(name: "Nguyễn Hoàng", avatar: "https://i.pravatar.cc/150?img=4", lastMessage: "Chiều nay đi cafe nhé?", time: "15/11", unread: 0),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Tin nhắn"), centerTitle: true),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];

          return ListTile(
            leading: CircleAvatar(radius: 26, backgroundImage: NetworkImage(user.avatar)),
            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(user.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(user.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                if (user.unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(12)),
                    child: Text("${user.unread}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomDemo(name: user.name)));
            },
          );
        },
      ),
    );
  }
}

class UserChatItem {
  final String name;
  final String avatar;
  final String lastMessage;
  final String time;
  final int unread;

  UserChatItem({required this.name, required this.avatar, required this.lastMessage, required this.time, required this.unread});
}

// -------------------------------
// Demo màn hình chat
// -------------------------------
class ChatRoomDemo extends StatelessWidget {
  final String name;

  const ChatRoomDemo({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: const Center(child: Text("Demo màn hình chat")),
    );
  }
}
