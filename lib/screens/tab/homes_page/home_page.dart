import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_mage_posting_page.dart';
import 'package:meko_project/screens/tab/tab_chat/tab_chat_page.dart';
import 'package:meko_project/screens/tab/tab_home/tab_home_page.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_page.dart';
import 'home_vm/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late HomeCubit cubit;
  int currentIndex = 0;

  final List<Widget> pages = [
    TabHomePage(),
    TabMagePostingPage(),
    TabChatPage(),
    TabProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    cubit = context.read<HomeCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (prev, curr) => curr.shouldShowPostSheet,
      listener: (context, state) {
        if (state.shouldShowPostSheet) {
          showPostSheet(context);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: currentIndex,
              children: pages,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 65 + bottomPadding,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 65,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildNavItem(
                            index: 0,
                            icon: Icons.home_outlined,
                            activeIcon: Icons.home_rounded,
                            label: 'Trang chủ',
                          ),
                          buildNavItem(
                            index: 1,
                            icon: Icons.label_outline,
                            activeIcon: Icons.label,
                            label: 'Quản lý tin',
                          ),
                          const SizedBox(width: 56),
                          buildNavItem(
                            index: 2,
                            icon: Icons.chat_bubble_outline,
                            activeIcon: Icons.chat_bubble,
                            label: 'Chat',
                          ),
                          buildNavItem(
                            index: 3,
                            icon: Icons.person_outline,
                            activeIcon: Icons.person,
                            label: 'Tài khoản',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: bottomPadding),
                  ],
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 28,
              bottom: 35 + bottomPadding,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  cubit.openPostSheet();
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFCF00),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFCF00).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? const Color(0xFFFFCF00) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? const Color(0xFFFFCF00) : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
            top: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Đăng tin',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Đăng ngay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCF00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Để sau'),
              ),
            ],
          ),
        );
      },
    );
  }
}