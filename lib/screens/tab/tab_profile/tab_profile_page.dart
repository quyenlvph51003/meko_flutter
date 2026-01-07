import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_cubit.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_state.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_button/app_button.dart';

class TabProfilePage extends StatefulWidget {
  const TabProfilePage({super.key});

  @override
  State<TabProfilePage> createState() {
    return TabProfilePageState();
  }
}

class TabProfilePageState extends State<TabProfilePage> with TickerProviderStateMixin {
  late TabProfileCubit vm;

  @override
  void initState() {
    super.initState();
    vm = TabProfileCubit(authRepository: getIt<AuthRepository>());
    vm.getUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
    vm.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: SafeArea(
          top: false,
          child: BlocBuilder<TabProfileCubit, TabProfileState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(bottom: 16, top: 24),
                        child: Column(
                          children: [
                            SizedBox(height: AppDimens.getHeight(context) * 0.05),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final result = await Navigator.of(context).pushNamed(AppRouterPaths.profileEditPage);
                                    if (result == true) {
                                      vm.getUserProfile();
                                    }
                                  },
                                  child: Container(
                                    width: 88,
                                    height: 88,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.shade300, width: 2),
                                      image: state.user.avatar != null
                                          ? DecorationImage(image: NetworkImage(state.user.avatar!), fit: BoxFit.cover)
                                          : null,
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   // right: MediaQuery.of(context).size.width / 2 - 44 - 6,
                                //   bottom: 6,
                                //   child: InkWell(
                                //     onTap: () {
                                //       context.read<TabProfileCubit>().pickAndUpdateAvatar(context);
                                //     },
                                //     child: Container(
                                //       width: 50,
                                //       height: 50,
                                //       decoration: BoxDecoration(
                                //         color: Colors.black87,
                                //         borderRadius: BorderRadius.circular(12),
                                //         border: Border.all(color: Colors.white, width: 2),
                                //       ),
                                //       child: const Icon(Icons.edit, color: Colors.white, size: 14),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(state.user.username ?? 'Chưa có tên', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Email: ${state.user.email ?? 'Chưa có email'}', style: const TextStyle(color: Colors.grey)),
                                // const Text(
                                //   '  •  ',
                                //   style: TextStyle(color: Colors.grey),
                                // ),
                                // Text(
                                //   'Đang theo dõi ${state.following}',
                                //   style: const TextStyle(color: Colors.grey),
                                // ),
                              ],
                            ),
                            // const SizedBox(height: 16),
                            // card số dư
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: cardDecoration(),
                              child: Column(
                                children: [
                                  // Row(
                                  //   children: [
                                  //     const Expanded(
                                  //       child: Row(
                                  //         children: [
                                  //           Text(
                                  //             'TK Định danh:',
                                  //             style: TextStyle(
                                  //               color: Colors.black54,
                                  //               fontWeight: FontWeight.w600,
                                  //             ),
                                  //           ),
                                  //           SizedBox(width: 6),
                                  //           Icon(
                                  //             Icons.info_outline,
                                  //             size: 16,
                                  //             color: Colors.black38,
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     Row(
                                  //       children: [
                                  //         Text(
                                  //           state.retrying
                                  //               ? 'Đang thử...'
                                  //               : 'Lỗi kết nối',
                                  //           style: const TextStyle(
                                  //             color: Colors.black54,
                                  //           ),
                                  //         ),
                                  //         const SizedBox(width: 8),
                                  //         InkWell(
                                  //           onTap: () {
                                  //             return;
                                  //           },
                                  //           child: Text(
                                  //             'Thử lại',
                                  //             style: TextStyle(
                                  //               color: Colors.blue[700],
                                  //               fontWeight: FontWeight.w600,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Text(
                                        'Số dư ví',
                                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${FormatUtils.formatCurrency(double.tryParse(state.user.walletBalance ?? '0') as num)}',
                                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.red, fontSize: 20),
                                      ),
                                      // const SizedBox(width: 6),
                                      // Container(
                                      //   width: 24,
                                      //   height: 24,
                                      //   decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFF3CD)),
                                      //   child: const Center(
                                      //     child: Text('ĐT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 44,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.cMain,
                                        foregroundColor: Colors.black87,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                      onPressed: () async {
                                        final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                        if (isCheckShowAuth) {
                                          Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                          return;
                                        }
                                        Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.topUpPage, (route) => true);
                                      },
                                      child: const Text('Nạp ngay'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      gapSection(),
                      sectionTitle('Tiện ích'),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: cardDecoration(),
                        child: Column(
                          children: [
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.orderListPage, (route) => true);
                              },
                              icon: Icons.shopping_bag_outlined,
                              title: 'Đơn hàng của tôi',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.packagePages, (route) => true);
                              },
                              icon: Icons.list,
                              title: 'Danh sách gói đăng',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.favoritePage, (route) => true);
                              },
                              icon: Icons.favorite_border,
                              title: 'Tin đăng đã lưu',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.historyPage, (route) => true);
                              },
                              icon: Icons.access_time,
                              title: 'Lịch sử xem tin',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.myReviewPage, (route) => true);
                              },
                              icon: Icons.star_border,
                              title: 'Đánh giá từ tôi',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.walletHistory, (route) => true);
                              },
                              icon: Icons.payment,
                              title: 'Lịch sử nạp tiền',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                _showChangePasswordDialog(context);
                              },
                              icon: Icons.key,
                              title: 'Đổi mật khẩu',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final isCheckShowAuth = await SqliteHelper.isCheckShowAuth(context);
                                if (isCheckShowAuth) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => true);
                                  return;
                                }
                                _showChangePinCodeWalletDialog(context);
                              },
                              icon: Icons.password,
                              title: 'Đổi mã pin',
                            ),
                            dividerInset(),
                            itemTile(
                              onTap: () async {
                                final navResult = await Navigator.of(context).pushNamed(
                                  AppRouterPaths.webviewPage,
                                  arguments: {
                                    'url': 'https://mekobe-production.up.railway.app/chinh-sach-quyen-rieng-tu',
                                    'title': 'Chính sách & quyền riêng tư',
                                    'successUrlContains': 'vnp_ResponseCode=00',
                                  },
                                );
                              },
                              icon: Icons.private_connectivity,
                              title: 'Chính sách & quyền riêng tư',
                            ),
                          ],
                        ),
                      ),
                      gapSection(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: AppButton(
                          onTap: () {
                            vm.logoutAccount(context);
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(14)),
                            child: const Row(
                              children: [
                                SizedBox(width: 16),
                                Icon(Icons.logout, color: Color(0xFFE53935)),
                                SizedBox(width: 12),
                                Text(
                                  'Đăng xuất',
                                  style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 40),
              backgroundColor: Colors.transparent, // để dễ custom màu
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header màu riêng
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColor.cMain, // màu header
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Center(
                        child: const Text(
                          'Đổi mật khẩu',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Body màu custom
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0F0), // màu body tùy chỉnh
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: oldCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Mật khẩu hiện tại',
                              labelStyle: TextStyle(color: AppColor.color1),
                              focusColor: AppColor.cMain,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.cMain)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: newCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Mật khẩu mới (min 6 kí tự)',
                              labelStyle: TextStyle(color: AppColor.color1),
                              focusColor: AppColor.cMain,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.cMain)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirmCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nhập lại mật khẩu mới',
                              labelStyle: TextStyle(color: AppColor.color1),
                              focusColor: AppColor.cMain,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.cMain)),
                            ),
                          ),
                          if (error != null) ...[const SizedBox(height: 8), Text(error!, style: const TextStyle(color: Colors.red))],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  final newP = newCtrl.text.trim();
                                  final confirmP = confirmCtrl.text.trim();
                                  if (newP.length < 6) {
                                    setState(() => error = 'Mật khẩu mới phải tối thiểu 6 kí tự');
                                    return;
                                  }
                                  if (newP != confirmP) {
                                    setState(() => error = 'Xác nhận mật khẩu không khớp');
                                    return;
                                  }
                                  setState(() => isLoading = true);
                                  context.read<TabProfileCubit>().changePage(ctx, oldCtrl.text, newCtrl.text);
                                  setState(() => isLoading = false);
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(AppColor.cMain),
                                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(backgroundColor: Colors.white, color: AppColor.cMain.withOpacity(0.3)),
                                        ),
                                      )
                                    : const Text('Cập nhật', style: TextStyle(fontSize: 15, color: Colors.white)),
                              ),
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
        );
      },
    );
  }

  //đổi mã pin ở ví
  void _showChangePinCodeWalletDialog(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;
    bool isLoading = false;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 40),
              backgroundColor: Colors.transparent, // để dễ custom màu
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header màu riêng
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColor.cMain, // màu header
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      child: Center(
                        child: const Text(
                          'Đổi mã pin',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // Body màu custom
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0F0), // màu body tùy chỉnh
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: oldCtrl,
                            obscureText: true,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Mật pin hiện tại',
                              labelStyle: TextStyle(color: AppColor.color1),
                              focusColor: AppColor.cMain,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.cMain)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: newCtrl,
                            obscureText: true,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Mã pin mới',
                              labelStyle: TextStyle(color: AppColor.color1),
                              focusColor: AppColor.cMain,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.cMain)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: confirmCtrl,
                            obscureText: true,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nhập lại mã pin mới',
                              labelStyle: TextStyle(color: AppColor.color1),
                              focusColor: AppColor.cMain,
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor.cMain)),
                            ),
                          ),
                          if (error != null) ...[const SizedBox(height: 8), Text(error!, style: const TextStyle(color: Colors.red))],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  final newP = newCtrl.text.trim();
                                  final confirmP = confirmCtrl.text.trim();
                                  if (newP.length < 6) {
                                    setState(() => error = 'Mã pin mới phải tối thiểu 6 kí tự');
                                    return;
                                  }
                                  if (newP != confirmP) {
                                    setState(() => error = 'Xác nhận mã pin không khớp');
                                    return;
                                  }
                                  setState(() => isLoading = true);
                                  await context.read<TabProfileCubit>().changePin(ctx, oldCtrl.text, newCtrl.text);
                                  setState(() => isLoading = false);
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(AppColor.cMain),
                                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Center(
                                          child: CircularProgressIndicator(backgroundColor: Colors.white, color: AppColor.cMain.withOpacity(0.3)),
                                        ),
                                      )
                                    : const Text('Cập nhật', style: TextStyle(fontSize: 15, color: Colors.white)),
                              ),
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
        );
      },
    );
  }

  Widget gapSection() {
    return const ColoredBox(color: Color(0xFFF7F7F7), child: SizedBox(height: 8));
  }

  Widget dividerInset() {
    return const Padding(padding: EdgeInsets.only(left: 56), child: Divider(height: 1));
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 4))],
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF6D6D6D)),
        ),
      ),
    );
  }

  Widget itemTile({required IconData icon, required String title, required Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      dense: true,
      minLeadingWidth: 32,
      onTap: onTap,
    );
  }
}
