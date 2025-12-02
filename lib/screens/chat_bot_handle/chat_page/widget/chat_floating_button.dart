import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_colcor.dart';

class ChatFloatingButton extends StatefulWidget {
  final VoidCallback onTap;

  const ChatFloatingButton({super.key, required this.onTap});

  @override
  State<ChatFloatingButton> createState() => _ChatFloatingButtonState();
}

class _ChatFloatingButtonState extends State<ChatFloatingButton> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scale;
  late final Animation<double> shadowSpread;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);

    scale = Tween<double>(begin: 0.96, end: 1.04).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    shadowSpread = Tween<double>(begin: 4, end: 10).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.cMain,
                boxShadow: [
                  BoxShadow(color: AppColor.cMain.withOpacity(0.4), blurRadius: shadowSpread.value, spreadRadius: 1, offset: const Offset(0, 4)),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 26),
                  Positioned(
                    top: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'AI',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColor.cMain),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
