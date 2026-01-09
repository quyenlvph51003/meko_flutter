import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/consts/app_paths.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_vm/tab_posting_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class PostManagerPage extends StatelessWidget {
  const PostManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return PostManagerCubit(postRepo: getIt<PostRepo>())..initCubit();
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
      body: PostManagerBody(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: buildFab(context),
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
        child: Row(children: [const Icon(Icons.network_cell, size: 16, color: Colors.black87)]),
      ),
      actions: [
        BlocBuilder<PostManagerCubit, PostManagerState>(
          buildWhen: (p, c) {
            return p.notificationCount != c.notificationCount;
          },
          builder: (context, state) {
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    Fluttertoast.showToast(msg: 'Chức năng này đang được phát triển', backgroundColor: Colors.red);
                  },
                  child: Stack(
                    children: [
                      IconButton(
                        onPressed: () {},
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
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'Chức năng này đang được phát triển', backgroundColor: Colors.red);
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black87),
                ),
              ],
            );
          },
        ),
      ],
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
                  buildChip(
                    context,
                    Icons.workspace_premium_outlined,
                    'Gói PRO',
                    Colors.black87,
                    Colors.grey.shade200,
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.packagePages, (route) => true);
                    },
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<PostManagerCubit, PostManagerState>(
                    buildWhen: (p, c) {
                      return p.voucherCount != c.voucherCount;
                    },
                    builder: (context, state) {
                      return buildChipWithBadge(
                        context,
                        Icons.card_giftcard,
                        'Ưu đãi',
                        state.voucherCount,
                        onTap: () {
                          Fluttertoast.showToast(msg: 'Chức năng này đang được phát triển', backgroundColor: Colors.red);
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  buildChip(
                    context,
                    Icons.people_outline,
                    'Danh sách liên hệ',
                    Colors.black87,
                    Colors.grey.shade200,
                    onTap: () {
                      Fluttertoast.showToast(msg: 'Chức năng này đang được phát triển', backgroundColor: Colors.red);
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<PostManagerCubit, PostManagerState>(
              buildWhen: (p, c) {
                return p.user != c.user;
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.cGray, width: 1),
                          image: DecorationImage(
                            image: state.user?.avatar != null ? NetworkImage(state.user!.avatar!) : AssetImage(AppImages.img_avt_default),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.user?.username ?? '', style: TextStyle(fontWeight: FontWeight.w600)),
                            AppButton(
                              onTap: () {
                                Navigator.of(context).pushNamed(AppRouterPaths.createPost);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.add_circle, color: Colors.green, size: 12),
                                  SizedBox(width: 4),
                                  Text('Đăng tin', style: TextStyle(color: AppColor.cMain, fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(16),
                      //     border: Border.all(color: AppColor.cMain, width: 1),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.monetization_on, size: 16, color: AppColor.cMain),
                      //       SizedBox(width: 4),
                      //       Text('DT'),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(width: 6),
                      // BlocBuilder<PostManagerCubit, PostManagerState>(
                      //   builder: (context, state) {
                      //     return Container(
                      //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(16),
                      //         border: Border.all(color: Colors.grey.shade300),
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           Text(state.dtPoint.toString()),
                      //           const SizedBox(width: 6),
                      //           InkWell(
                      //             onTap: () {
                      //               context.read<PostManagerCubit>().increaseDT();
                      //             },
                      //             child: const Icon(Icons.add_circle, color: Colors.green, size: 18),
                      //           ),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                );
              },
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
        child: Row(
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: fg)),
          ],
        ),
      ),
    );
  }

  Widget buildChipWithBadge(BuildContext context, IconData icon, String label, int count, {VoidCallback? onTap}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        buildChip(context, icon, label, Colors.black87, Colors.grey.shade200, onTap: onTap),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
              child: Text(
                count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
              ),
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
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  tabItem(context, 'Chờ duyệt', PostStatus.PENDING, state.currentTab),
                  SizedBox(width: 8), // khoảng cách giữa tab
                  tabItem(context, 'Đang hiển thị', PostStatus.APPROVED, state.currentTab),
                  SizedBox(width: 8),
                  tabItem(context, 'Đã ẩn', PostStatus.HIDDEN, state.currentTab),
                  SizedBox(width: 8),
                  tabItem(context, 'Hết hạn', PostStatus.EXPIRED, state.currentTab),
                  SizedBox(width: 8),
                  tabItem(context, 'Từ chối', PostStatus.REJECTED, state.currentTab),
                  SizedBox(width: 8),
                  tabItem(context, 'Vi phạm', PostStatus.VIOLATION, state.currentTab),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tabItem(BuildContext context, String label, PostStatus tab, PostStatus current) {
    final isActive = tab == current;
    return InkWell(
      onTap: () {
        context.read<PostManagerCubit>().selectTab(tab);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        alignment: Alignment.center,
        // height: 30,
        decoration: BoxDecoration(color: isActive ? AppColor.cMain : Colors.white, borderRadius: BorderRadius.circular(22)),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? Colors.white : Colors.black54),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostManagerCubit, PostManagerState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: AppLoader());
        }
        if (state.listings.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: AppDimens.getHeight(context) * 0.1),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 60),
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.image_outlined, size: 64, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text('Không tìm thấy tin đăng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Bạn hiện tại không có tin đăng nào cho trạng thái này', textAlign: TextAlign.center),
              ],
            ),
          );
        }
        return RefreshLoadmore(
          isLastPage: state.isLastPage,
          onRefresh: () async {
            context.read<PostManagerCubit>().getPostByStatus();
          },
          onLoadmore: () async {
            print('đâsdasd');
            context.read<PostManagerCubit>().onLoadMore();
          },
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 100, top: 10),
            itemCount: state.listings.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.withValues(alpha: 0.5), height: 10, thickness: 1),
            itemBuilder: (context, index) {
              final item = state.listings[index];
              return GestureDetector(
                onTap: () {
                  if (state.currentTab != PostStatus.PENDING && state.currentTab != PostStatus.REJECTED) {
                    context.read<PostManagerCubit>().onProductTap(context, index, item);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Ảnh sản phẩm bên trái
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.images[0],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Icon(Icons.image, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Nội dung bên phải
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Visibility(
                                  visible: item.status == 'PENDING',
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(AppRouterPaths.updatePostPage, arguments: {'postId': item.id});
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Icon(Icons.edit, color: Colors.grey, size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              item.description,
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FormatUtils.formatCurrency(double.tryParse(item.price ?? '0') ?? 0),
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE53935)),
                                ),
                                Text('${FormatUtils.timeAgo(item.updatedAt.toString())}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
