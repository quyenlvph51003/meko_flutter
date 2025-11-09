// post_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
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
  @override
  void initState() {
    super.initState();
    imageController = PageController();
    getUser();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
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
    final phone = (raw ?? '').replaceAll(RegExp(r'[^0-9+]'), '');
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không có số điện thoại hợp lệ')));
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể mở gọi với số $phone')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PostDetailCubit(item: widget.item, loader: widget.loadDetail, favoriteRepo: getIt<FavoriteRepo>())
            ..init((widget.item.id == 0) ? (widget.item.postId ?? 0) : widget.item.id),
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
                                  onTap: () {
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
                                // const SizedBox(width: 5),
                                // Container(
                                //   width: 40,
                                //   height: 40,
                                //   decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                                //   child: const Icon(Icons.share_outlined, size: 20, color: Colors.black),
                                // ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
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
                                                leading: Icon(Icons.warning_amber_outlined),
                                                contentPadding: EdgeInsets.zero,
                                                title: Text('Báo cáo vi phạm', style: TextStyle(color: Colors.black, fontSize: 14)),
                                              ),
                                              Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                                              ListTile(
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                                  child: Icon(Icons.favorite_border, size: 16, color: Colors.grey[600]),
                                ),
                                const SizedBox(width: 8),
                                Text('Lưu', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
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
                                      // const SizedBox(width: 8),
                                      // Text('2002 Đã bán', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                    ],
                                  ),
                                  // const SizedBox(height: 4),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: 6,
                                  //       height: 6,
                                  //       decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                  //     ),
                                  //     const SizedBox(width: 6),
                                  //     Text('Hoạt động 4 giờ trước', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Icon(Icons.phone, size: 25, color: AppColor.cMain),
                                ),
                                // const SizedBox(width: 8),
                                // Container(
                                //   width: 40,
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     border: Border.all(color: Colors.grey[300]!),
                                //   ),
                                //   child: Icon(Icons.star_border, size: 18, color: Colors.grey[600]),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[200]),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      //   child: Row(
                      //     children: [
                      //       const Text('Chat nhanh:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: Row(
                      //           children: [
                      //             Expanded(
                      //               child: Container(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(color: Colors.grey[300]!),
                      //                   borderRadius: BorderRadius.circular(4),
                      //                 ),
                      //                 child: Text(
                      //                   'Bạn có ship gà không?',
                      //                   style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      //                   maxLines: 1,
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(width: 8),
                      //             Expanded(
                      //               child: Container(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(color: Colors.grey[300]!),
                      //                   borderRadius: BorderRadius.circular(4),
                      //                 ),
                      //                 child: Text(
                      //                   'Gà này còn không?',
                      //                   style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      //                   maxLines: 1,
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Divider(height: 1, color: Colors.grey[200]),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
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
                            const SizedBox(width: 8),
                            const Icon(Icons.send, size: 25, color: Colors.grey),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.account_circle_outlined, size: 18, color: Colors.grey[600]),
                      //       const SizedBox(width: 8),
                      //       Expanded(
                      //         child: Text(
                      //           state.item.phoneNumber.isEmpty ? 'SDT liên hệ: Đang cập nhật' : 'SDT liên hệ: ${state.item.phoneNumber}',
                      //           style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      //           maxLines: 1,
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 8),
                      //       GestureDetector(
                      //         onTap: () {
                      //           callPhone(context, state.item.phoneNumber);
                      //         },
                      //         child: const Text(
                      //           'Gọi ngay',
                      //           style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.sms, color: Colors.grey[600], size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            onTap: () {
                              callPhone(context, state.item.phoneNumber);
                              print('Da click vao sdt de goi + ${state.item.phoneNumber}');
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
