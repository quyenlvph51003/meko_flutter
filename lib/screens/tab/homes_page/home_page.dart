import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/global_data/data_local/hive_db.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/login_page/login_page.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_page.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_page.dart';
import 'package:meko_project/screens/tab/tab_chat/tab_chat_page.dart';
import 'package:meko_project/screens/tab/tab_home/tab_home_page.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_page.dart';
import 'package:meko_project/services/socket_service.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/utils/login_global/login_global.dart';
import 'home_vm/home_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit vm;

  @override
  void initState() {
    super.initState();
    vm = context.read<HomeCubit>();
    SocketService().connect();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final pages = const [TabHomePage(), PostManagerPage(), TabChatPage(), TabProfilePage()];

    // Use default BottomNavigationBar height (kBottomNavigationBarHeight = 56)
    const double bottomNavHeight = kBottomNavigationBarHeight;
    final fabSize = screenWidth < 360 ? 48.0 : 56.0;
    final fabIconSize = screenWidth < 360 ? 28.0 : 32.0;

    return BlocListener<HomeCubit, HomeState>(
      // listenWhen: (p, c) => c.shouldShowPostSheet,
      listener: (context, state) {
        if (state.shouldShowPostSheet) {
          showPostSheet(context);
          return;
        }
        if (state.isLoggedIn) {
        } else {
          if (state.isCheckShowAuth ?? false) {
            Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (p, c) => p.currentIndex != c.currentIndex || p.isLoggedIn != c.isLoggedIn || p.uiRev != c.uiRev,
              builder: (context, state) {
                // Return the active page directly so it rebuilds when the tab changes.
                // This replaces the previous IndexedStack which preserved the state of
                // all pages. Now tapping a tab will recreate/load its page.
                return pages[state.currentIndex];
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, -1))],
                ),
                child: SafeArea(
                  top: false,
                  child: BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (p, c) => p.currentIndex != c.currentIndex || p.isLoggedIn != c.isLoggedIn || p.uiRev != c.uiRev,
                    builder: (context, state) {
                      return BottomNavigationBar(
                        currentIndex: state.currentIndex,
                        onTap: (index) {
                          context.read<HomeCubit>().changeTab(index);
                        },
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: AppColor.cMain,
                        unselectedItemColor: Colors.grey,
                        showUnselectedLabels: true,
                        selectedFontSize: 11,
                        unselectedFontSize: 11,
                        iconSize: 24,
                        items: const [
                          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Trang chủ'),
                          BottomNavigationBarItem(icon: Icon(Icons.label_outline), activeIcon: Icon(Icons.label), label: 'Quản lý tin'),
                          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
                          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Tài khoản'),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: (screenWidth - fabSize) / 2,
              bottom: (bottomNavHeight / 2) + bottomPadding,
              child: GestureDetector(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                  if (isCheckShowAuth) {
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                    return;
                  } else {
                    Navigator.of(context).pushNamed(AppRouterPaths.createPost);
                  }
                },
                child: Container(
                  width: fabSize,
                  height: fabSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.cMain,
                    boxShadow: [BoxShadow(color: AppColor.color8.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Icon(Icons.add_rounded, color: Colors.white, size: fabIconSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          HapticFeedback.lightImpact();
          final needAuth = (index == 1 || index == 2 || index == 3);
          if (needAuth && !vm.state.isLoggedIn) {
            final ok = await showAuthBottomSheet(
              context,
              loginPage: LoginPage(
                onSuccess: () {
                  print('duongqinaguye');
                  Navigator.pop(context, true);
                  return;
                },
                onTapRegister: () {
                  DefaultTabController.of(context).animateTo(1);
                  return;
                },
              ),
              registerPage: SignUpPage(
                onSuccess: () {
                  DefaultTabController.of(context).animateTo(0);
                  return;
                },
                onBackToLogin: () {
                  DefaultTabController.of(context).animateTo(0);
                },
              ),
            );
            if (ok == true) {
              await vm.isCheckLogin();
              vm.changeTab(index);
            }
            return;
          }
          vm.changeTab(index);
          return;
        },

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, size: 24, color: isActive ? AppColor.cMain : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? AppColor.cMain : Colors.grey,
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom, top: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Đăng tin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    return;
                  },
                  icon: const Icon(Icons.cloud_upload_outlined),
                  label: const Text('Đăng ngay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCF00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  return;
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
