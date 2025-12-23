// post_detail_page.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/consts/app_paths.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/review/reply_model.dart';
import 'package:meko_project/models/body/review/review_model.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/models/body/violation/violation_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/repository/report/report_repo.dart';
import 'package:meko_project/repository/reviews/review_repo.dart';
import 'package:meko_project/repository/rating/rating_repo.dart';
import 'package:meko_project/repository/violation/violation_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/chat_page/chat_page_screen.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/screens/post_detail_page/post_detail_vm/post_detail_cubit.dart';
import 'package:meko_project/screens/post_detail_page/post_detail_vm/post_detail_state.dart';
import '../../models/body/post/listing_item_model.dart' show ListingItem;

class PostDetailPage extends StatefulWidget {
  final ListingItem item;
  final Future<ListingItem> Function(int id) loadDetail;
  const PostDetailPage({Key? key, required this.item, required this.loadDetail}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PageController imageController;
  UserModel? user;
  late TextEditingController controller;
  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    imageController = PageController();
    getUser();
    controller = TextEditingController();
    focusNode = FocusNode();
  }

  void _showRatingBottomSheet(BuildContext context, PostDetailCubit vm, PostDetailState state) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        int current = state.myRating ?? state.item.rating ?? 0;
        return StatefulBuilder(
          builder: (context, setStateSB) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Chọn số sao đánh giá', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (index) {
                      final filled = current > index;
                      return GestureDetector(
                        onTap: () {
                          setStateSB(() {
                            current = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(filled ? Icons.star : Icons.star_border, size: 32, color: Colors.amber),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onTap: () async {
                        await vm.submitRating(current);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text('Gửi đánh giá', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
    controller.dispose();
    focusNode.dispose();
  }

  Future<void> getUser() async {
    final userSql = await SqliteHelper.getUserSql();
    if (userSql != null) {
      setState(() {
        user = userSql;
      });
    }
  }

  Future<void> callPhone(BuildContext context, String? raw) async {
    String phone = (raw ?? '').replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.startsWith('0')) {
      phone = '+84${phone.substring(1)}';
    }

    final uri = Uri(scheme: 'tel', path: phone);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication); // ❗ bỏ mode: LaunchMode.externalApplication
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thiết bị không hỗ trợ gọi điện với số $phone')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi khi mở gọi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostDetailCubit(
        item: widget.item,
        loader: widget.loadDetail,
        favoriteRepo: getIt<FavoriteRepo>(),
        reviewRepo: getIt<ReviewRepo>(),
        violationRepo: getIt<ViolationRepo>(),
        reportRepo: getIt<ReportRepo>(),
        ratingRepo: getIt<RatingRepo>(),
      )..init((widget.item.id == 0) ? (widget.item.postId ?? 0) : widget.item.id),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<PostDetailCubit, PostDetailState>(
          buildWhen: (p, n) {
            if (p.currentImageIndex != n.currentImageIndex) {
              return true;
            }
            if (p.isLiked != n.isLiked) {
              return true;
            }
            if (p.descriptionExpanded != n.descriptionExpanded) {
              return true;
            }
            if (p.item != n.item) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            final vm = context.read<PostDetailCubit>();
            final images = state.item.images;
            final categories = state.item.categories;
            final item = state.item;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 400,
                            color: Colors.grey[200],
                            child: PageView.builder(
                              controller: imageController,
                              onPageChanged: (index) {
                                vm.changeImageIndex(index);
                              },
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  images[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey)),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: AppDimens.getTop(context),
                            left: 16,
                            right: 16,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                                    child: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                    if (isCheckShowAuth) {
                                      Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                      return;
                                    }
                                    vm.toggleLike();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                                    child: Icon(
                                      state.isLiked ? Icons.favorite : Icons.favorite_border,
                                      size: 20,
                                      color: state.isLiked ? Colors.red : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () async {
                                    final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                    if (isCheckShowAuth) {
                                      Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                      return;
                                    }
                                    showModalBottomSheet(
                                      context: context,
                                      isDismissible: true, // tap ra ngoài để đóng
                                      backgroundColor: Colors.white, // màu background của bottom sheet
                                      barrierColor: Colors.black.withOpacity(0.5), // làm mờ màn hình
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                                      builder: (context) {
                                        return Container(
                                          height: 230,
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Icon(Icons.cancel, size: 25, color: Colors.black),
                                              ),
                                              Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                                              ListTile(
                                                onTap: () {
                                                  //reset
                                                  vm.fetchListViolation();
                                                  vm.changeViolationSelected(null);
                                                  showViolationBottom(context, vm);
                                                },
                                                leading: Icon(Icons.warning_amber_outlined),
                                                contentPadding: EdgeInsets.zero,
                                                title: Text('Báo cáo vi phạm', style: TextStyle(color: Colors.black, fontSize: 14)),
                                              ),
                                              Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                                              ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                leading: Icon(Icons.support_agent_sharp),
                                                contentPadding: EdgeInsets.zero,
                                                title: Text('Cần trợ giúp?', style: TextStyle(color: Colors.black, fontSize: 14)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                                    child: const Icon(Icons.more_vert, size: 20, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                '${state.currentImageIndex + 1}/${images.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          if (state.currentImageIndex > 0)
                            Positioned(
                              left: 12,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    imageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  },
                                  child: Icon(Icons.chevron_left, color: Colors.white.withOpacity(0.6), size: 40),
                                ),
                              ),
                            ),
                          if (state.currentImageIndex < images.length - 1)
                            Positioned(
                              right: 12,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    imageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  },
                                  child: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.6), size: 40),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categories.isNotEmpty ? categories.join(' / ') : 'Danh mục',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.4),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.item.title,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  FormatUtils.formatCurrency(double.tryParse(item.price) ?? 0),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                    if (isCheckShowAuth) {
                                      Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                      return;
                                    }
                                    vm.toggleLike();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                                    child: Icon(
                                      state.isLiked ? Icons.favorite : Icons.favorite_border,
                                      size: 16,
                                      color: state.isLiked ? Colors.red : Colors.grey[600],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('Lưu', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                _showRatingBottomSheet(context, vm, state);
                              },
                              child: Row(
                                children: [
                                  const Text('Đánh giá của bạn:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 8),
                                  ...List.generate(5, (index) {
                                    final current = state.myRating ?? state.item.rating ?? 0;
                                    final filled = current > index;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Icon(filled ? Icons.star : Icons.star_border, size: 22, color: Colors.amber),
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  Text('${state.myRating ?? state.item.rating ?? 0}/5', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.item.address,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.my_location, size: 16, color: Colors.blue),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(
                                  'Cập nhật ${FormatUtils.timeAgo(item.updatedAt?.toString() ?? '')}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: item.avatarPoster != null ? NetworkImage(item.avatarPoster!) : AssetImage(AppImages.img_avt_default),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(state.item.userNamePoster, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Email: ${item.emailPoster}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    callPhone(context, item.phoneNumber);
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Icon(Icons.phone, size: 25, color: AppColor.cMain),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Mô tả chi tiết', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Text(
                                state.item.description,
                                maxLines: state.descriptionExpanded ? null : 3,
                                overflow: state.descriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  vm.toggleDescription();
                                },
                                child: Text(
                                  state.descriptionExpanded ? 'Thu gọn' : 'Xem thêm',
                                  style: const TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Bình luận',
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (state.reviews.isNotEmpty)
                              Column(
                                children: [
                                  ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: math.min(3, state.reviews.length),
                                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final review = state.reviews[index];
                                      return Column(
                                        children: [
                                          _buildReview(
                                            review: review,
                                            onTapReply: (ReviewModel parent) async {
                                              final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                              if (isCheckShowAuth) {
                                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                                return;
                                              }
                                              vm.changeReviewReply(parent);
                                              _showBottomComment(context, vm: vm, controller: controller, focusNode: focusNode, user: user);
                                            },
                                            user: user,
                                            vm: vm,
                                            context: context,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Visibility(visible: state.reviews.length > 3, child: const SizedBox(height: 15)),
                                  Visibility(
                                    visible: state.reviews.length > 3,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                        if (isCheckShowAuth) {
                                          Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                          return;
                                        }
                                        vm.changeAutoFocus(true);
                                        vm.changeReviewReply(null);
                                        _showBottomComment(
                                          context,
                                          userAvatar: user?.avatar ?? '',
                                          vm: vm,
                                          controller: controller,
                                          focusNode: focusNode,
                                          user: user,
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Xem thêm ${state.reviews.length - 3} bình luận',
                                          style: TextStyle(fontSize: 15, color: Colors.black, decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (state.reviews.isEmpty)
                              Column(
                                children: [
                                  Container(
                                    width: 85,
                                    height: 85,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
                                    child: Center(child: Image.asset(AppImages.icon_no_comments, width: 35, height: 35, color: Colors.grey[600])),
                                  ),
                                  SizedBox(height: 8),
                                  const Text(
                                    'Chưa có bình luận nào.\n Hãy để lại bình luận cho người bán.',
                                    style: TextStyle(fontSize: 13, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                  if (isCheckShowAuth) {
                                    Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                    return;
                                  }
                                  vm.changeAutoFocus(true);
                                  vm.changeReviewReply(null);
                                  _showBottomComment(
                                    context,
                                    userAvatar: user?.avatar ?? '',
                                    vm: vm,
                                    controller: controller,
                                    focusNode: focusNode,
                                    user: user,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.grey[200],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: user?.avatar != null
                                              ? DecorationImage(image: NetworkImage(user!.avatar!), fit: BoxFit.cover)
                                              : DecorationImage(image: AssetImage(AppImages.img_avt_default), fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Bình luận...', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.send, size: 25, color: Colors.grey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: AppDimens.getBottom(context), left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // border: Border(top: BorderSide(color: AppColor.cGray70)),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // Fluttertoast.showToast(msg: 'Chức năng này đang được phát triển', backgroundColor: Colors.red);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPageScreen(
                                  name: item.userNamePoster,
                                  // conversationId: null,
                                  avt: item.avatarPoster ?? '',
                                  partner_id: item.userPostId,
                                  // partner_id: item.u,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.sms, color: Colors.grey[600], size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            onTap: () {
                              callPhone(context, state.item.phoneNumber);
                            },
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(color: AppColor.color5, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.call, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Gọi điện cho người bán',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _buildReply({ReplyModel? reply, UserModel? user, required BuildContext context, required PostDetailCubit vm, bool? isDetail}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          image: DecorationImage(
            image: reply?.replyUserAvatar != null ? NetworkImage(reply!.replyUserAvatar!) : AssetImage(AppImages.img_avt_default),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reply?.replyUser ?? '',
                        style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                      Visibility(
                        visible: user?.id == reply?.replyUserId,
                        child: GestureDetector(
                          onTap: () {
                            if (isDetail == true) {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit, color: Colors.red),
                                          title: const Text('Chỉnh sửa', style: TextStyle(color: Colors.black)),
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            vm.changeEdit(true);
                                            vm.changeReplyEdit(reply);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete, color: Colors.red),
                                          title: const Text('Xóa bình luận', style: TextStyle(color: Colors.black)),
                                          onTap: () {
                                            if (isDetail == true) {
                                              Navigator.pop(ctx);
                                              vm.deleteReview(reviewId: reply?.replyId ?? 0);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.more_vert, color: Colors.black.withValues(alpha: 0.5), size: 20),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    reply?.replyComment ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  FormatUtils.timeAgo(
                    (reply?.replyCreatedAt ?? '').split('.').first.replaceAll(' ', 'T') + 'Z', // thêm Z cho UTC
                  ),
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildReview({
  required ReviewModel review,
  required Function(ReviewModel parent) onTapReply,
  bool? isDetail,
  UserModel? user,
  required PostDetailCubit vm,
  required BuildContext context,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
          image: DecorationImage(
            image: review.reviewUserAvatar != null ? NetworkImage(review.reviewUserAvatar!) : AssetImage(AppImages.img_avt_default),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          review.reviewUser ?? '',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Visibility(
                        visible: user?.id == review.reviewUserId,
                        child: GestureDetector(
                          onTap: () {
                            if (isDetail == true) {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.edit, color: Colors.red),
                                          title: const Text('Chỉnh sửa', style: TextStyle(color: Colors.black)),
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            vm.changeEdit(true);
                                            vm.changeReviewReply(review, isEdit: true);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.delete, color: Colors.red),
                                          title: const Text('Xóa bình luận', style: TextStyle(color: Colors.black)),
                                          onTap: () {
                                            if (isDetail == true) {
                                              Navigator.pop(ctx);
                                              vm.deleteReview(reviewId: review.reviewId ?? 0);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.more_vert, color: Colors.black.withValues(alpha: 0.5), size: 20),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    review.reviewComment ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    onTapReply(review);
                  },
                  child: Text('Trả lời', style: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
                Text(
                  FormatUtils.timeAgo(review.reviewCreatedAt ?? ''),
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (review.replies?.isNotEmpty ?? false)
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: isDetail == true ? review.replies?.length ?? 0 : math.min(1, review.replies?.length ?? 0),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final reply = review.replies?[index];
                  return _buildReply(reply: reply, user: user, context: context, vm: vm, isDetail: isDetail);
                },
              ),
          ],
        ),
      ),
    ],
  );
}

void _showBottomComment(
  BuildContext context, {
  String? userAvatar,
  required PostDetailCubit vm,
  required TextEditingController controller,
  required FocusNode focusNode,
  UserModel? user,
}) {
  showModalBottomSheet(
    isDismissible: true,
    backgroundColor: Colors.white,
    barrierColor: Colors.black.withOpacity(0.5),
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (ctx) {
      return BlocProvider.value(
        value: vm,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: BlocBuilder<PostDetailCubit, PostDetailState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Bình luận', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: state.reviews.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final review = state.reviews[index];
                            return Column(
                              children: [
                                _buildReview(
                                  review: review,
                                  onTapReply: (ReviewModel parent) {
                                    focusNode.requestFocus();
                                    vm.changeReviewReply(parent);
                                  },
                                  isDetail: true,
                                  user: user,
                                  vm: vm,
                                  context: context,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.reviewReply != null || state.reply != null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: (state.reply != null || (state.isEdit ?? false)) ? 'Đang chỉnh sửa ' : 'Đang trả lời ',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                  children: [
                                    TextSpan(
                                      text: state.reply != null ? state.reply?.replyUser ?? '' : state.reviewReply?.reviewUser ?? '',
                                      style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  focusNode.unfocus();
                                  vm.changeReviewReply(null);
                                },
                                child: Text('Hủy bỏ', style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.8))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.grey[200],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: userAvatar != null
                                            ? DecorationImage(image: NetworkImage(userAvatar), fit: BoxFit.cover)
                                            : DecorationImage(image: AssetImage(AppImages.img_avt_default), fit: BoxFit.cover),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: controller,
                                        onChanged: (value) {
                                          vm.changeComment(value);
                                        },
                                        focusNode: focusNode,
                                        autofocus: true,
                                        style: const TextStyle(fontSize: 12, height: 1.0),
                                        strutStyle: const StrutStyle(fontSize: 12, height: 1.0, forceStrutHeight: true),
                                        minLines: 1,
                                        maxLines: 1,
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                          border: InputBorder.none,
                                          hintText: 'Bình luận...',
                                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (controller.text.isNotEmpty) {
                                vm.changeComment('');
                                controller.clear();
                                focusNode.unfocus();
                                if (state.isEdit ?? false) {
                                  vm.updateReview(
                                    reviewId: state.reply != null ? state.reply?.replyId ?? 0 : state.reviewReply?.reviewId ?? 0,
                                    content: state.commentController.text,
                                  );
                                } else {
                                  vm.createReview(
                                    postId: state.item.id == 0 ? (state.item.postId ?? 0) : (state.item.id),
                                    content: state.commentController.text,
                                  );
                                }
                                vm.changeReviewReply(null);
                                vm.changeReplyEdit(null);
                                vm.changeEdit(false);
                              }
                            },
                            child: Icon(Icons.send, size: 25, color: state.commentController.text.isEmpty ? Colors.grey : AppColor.cMain),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

void showViolationBottom(BuildContext context, PostDetailCubit vm) {
  final controller = TextEditingController();
  showModalBottomSheet(
    context: context,
    isDismissible: true, // tap ra ngoài để đóng
    backgroundColor: Colors.white, // màu background của bottom sheet
    barrierColor: Colors.black.withOpacity(0.5), // làm mờ màn hình
    useSafeArea: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) {
      return BlocProvider.value(
        value: vm,
        child: BlocBuilder<PostDetailCubit, PostDetailState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Báo cáo vi phạm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                    if (state.violations.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.violations.length,
                            itemBuilder: (cont, index) {
                              final item = state.violations[index];
                              // bản chất 2 obj giống nhau
                              return RadioListTile<ViolationModel>(
                                value: item,
                                groupValue: state.violationSelected,
                                activeColor: AppColor.cMain,
                                onChanged: (value) {
                                  if (value != null) {
                                    vm.changeViolationSelected(value);
                                    // Nếu bạn muốn đóng bottom sheet sau khi chọn thì bật dòng này:
                                    // Navigator.pop(context);
                                  }
                                },
                                title: Text(item.name ?? ''),
                              );
                            },
                          ),
                        ),
                      ),
                    if (state.violationSelected != null)
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Ô nhập mô tả chiếm hết phần còn lại
                            Expanded(
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                  focusColor: AppColor.cMain,
                                  border: OutlineInputBorder(),
                                  hintText: 'Mô tả(Không bắt buộc)',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                maxLines: 1, // Nếu muốn multiline thì tăng lên
                              ),
                            ),
                            SizedBox(width: 8),
                            // Nút gửi
                            ElevatedButton(
                              onPressed: () {
                                if (state.violationSelected != null) {
                                  vm.createReportCubit(content: controller.text);
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              child: Text('Gửi', style: TextStyle(color: Colors.white)),
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
