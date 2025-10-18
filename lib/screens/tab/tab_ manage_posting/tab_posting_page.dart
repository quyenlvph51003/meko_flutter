
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_vm/tab_posting_cubit.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_vm/tab_posting_state.dart';

class PostManagerPage extends StatelessWidget {
  const PostManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PostManagerCubit();
      },
      child: const PostManagerView(),
    );
  }
}

class PostManagerView extends StatelessWidget {
  const PostManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: buildAppBar(context),
      body: const PostManagerBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: buildFab(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        'Quản lý tin đăng',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Row(children: [
          const Icon(Icons.network_cell, size: 16, color: Colors.black87),
        ]),
      ),
      actions: [
        BlocBuilder<PostManagerCubit, PostManagerState>(
          buildWhen: (p, c) {
            return p.notificationCount != c.notificationCount;
          },
          builder: (context, state) {
            return Row(children: [
              Stack(children: [
                IconButton(
                  onPressed: () {
                    return;
                  },
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                ),
                if (state.notificationCount > 0)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      height: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(9)),
                      child: Center(
                        child: Text(
                          state.notificationCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
              ]),
              IconButton(
                onPressed: () {
                  return;
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black87),
              ),
            ]);
          },
        ),
      ],
    );
  }

  Widget buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        return;
      },
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }


}



class PostManagerBody extends StatelessWidget {
  const PostManagerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderStrip(),
        const SizedBox(height: 8),
        const TabBarStrip(),
        const Expanded(child: EmptyState()),
      ],
    );
  }
}

class HeaderStrip extends StatelessWidget {
  const HeaderStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  buildChip(context, Icons.workspace_premium_outlined, 'Gói PRO', Colors.black87, Colors.grey.shade200, onTap: () {
                    return;
                  }),
                  const SizedBox(width: 8),
                  BlocBuilder<PostManagerCubit, PostManagerState>(
                    buildWhen: (p, c) {
                      return p.voucherCount != c.voucherCount;
                    },
                    builder: (context, state) {
                      return buildChipWithBadge(context, Icons.card_giftcard, 'Ưu đãi', state.voucherCount);
                    },
                  ),
                  const SizedBox(width: 8),
                  buildChip(context, Icons.people_outline, 'Danh sách liên hệ', Colors.black87, Colors.grey.shade200, onTap: () {
                    return;
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColor.cMain,
                    child: const Text('V', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Vương Toàn Quyền', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColor.cMain, width: 1)),
                    child: Row(children: [
                      Icon(Icons.monetization_on, size: 16, color: AppColor.cMain),
                      SizedBox(width: 4),
                      Text('DT'),
                    ]),
                  ),
                  const SizedBox(width: 6),
                  BlocBuilder<PostManagerCubit, PostManagerState>(
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
                        child: Row(children: [
                          Text(state.dtPoint.toString()),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              context.read<PostManagerCubit>().increaseDT();
                            },
                            child: const Icon(Icons.add_circle, color: Colors.green, size: 18),
                          ),
                        ]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChip(BuildContext context, IconData icon, String label, Color fg, Color bg, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
        child: Row(children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: fg)),
        ]),
      ),
    );
  }

  Widget buildChipWithBadge(BuildContext context, IconData icon, String label, int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        buildChip(context, icon, label, Colors.black87, Colors.grey.shade200, onTap: () {
          return;
        }),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }
}

class TabBarStrip extends StatelessWidget {
  const TabBarStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: BlocBuilder<PostManagerCubit, PostManagerState>(
        buildWhen: (p, c) {
          return p.currentTab != c.currentTab;
        },
        builder: (context, state) {
          return Row(
            children: [
              Expanded(child: tabItem(context, 'ĐANG HIỂN THỊ', PostTab.dangHienThi, state.currentTab)),
              Expanded(child: tabItem(context, 'HẾT HẠN', PostTab.hetHan, state.currentTab)),
              Expanded(child: tabItem(context, 'BỊ TỪ CHỐI', PostTab.biTuChoi, state.currentTab)),
              Expanded(child: tabItem(context, 'CẦN BỔ SUNG', PostTab.canBoSung, state.currentTab)),
            ],
          );
        },
      ),
    );
  }

  Widget tabItem(BuildContext context, String label, PostTab tab, PostTab current) {
    final isActive = tab == current;
    return InkWell(
      onTap: () {
        context.read<PostManagerCubit>().selectTab(tab);
      },
      child: Container(
        alignment: Alignment.center,
        height: 44,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isActive ? AppColor.cMain : Colors.transparent, width: 2)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? Colors.black : Colors.black54),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(

        children: [
        SizedBox(
          height: AppDimens.getHeight(context)*0.1,
        ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 60),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.image_outlined, size: 64, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          const Text('Không tìm thấy tin đăng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Bạn hiện tại không có tin đăng nào cho trạng thái này', textAlign: TextAlign.center),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () {
              return;
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Đăng tin', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

