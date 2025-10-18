import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_cubit.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_state.dart';
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
                              CircleAvatar(
                                radius: 44,
                                backgroundColor: AppColor.cMain,
                                child: const Text(
                                  'V',
                                  style: TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ),
                              Positioned(
                                right: MediaQuery.of(context).size.width / 2 - 44 - 6,
                                bottom: 6,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(state.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Người theo dõi ${state.followers}', style: const TextStyle(color: Colors.grey)),
                              const Text('  •  ', style: TextStyle(color: Colors.grey)),
                              Text('Đang theo dõi ${state.following}', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // card số dư
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: cardDecoration(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Row(
                                        children: [
                                          Text('TK Định danh:', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                                          SizedBox(width: 6),
                                          Icon(Icons.info_outline, size: 16, color: Colors.black38),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(state.retrying ? 'Đang thử...' : 'Lỗi kết nối', style: const TextStyle(color: Colors.black54)),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () { return; },
                                          child: Text('Thử lại', style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text('Đồng Tốt', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    Text('${state.coins}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 6),
                                    Container(
                                      width: 24, height: 24,
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFF3CD)),
                                      child: const Center(child: Text('ĐT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700))),
                                    ),
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
                                    onPressed: () { return; },
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
                          itemTile(icon: Icons.favorite_border, title: 'Tin đăng đã lưu'),
                          dividerInset(),
                          itemTile(icon: Icons.bookmark_border, title: 'Tìm kiếm đã lưu'),
                          dividerInset(),
                          itemTile(icon: Icons.access_time, title: 'Lịch sử xem tin'),
                          dividerInset(),
                          itemTile(icon: Icons.star_border, title: 'Đánh giá từ tôi'),
                        ],
                      ),
                    ),
                    gapSection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: AppButton(
                        onTap: () {
                          vm.logoutAccount();
                          print('sdfsdfsdf');
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(14)),
                          child: const Row(
                            children: [
                              SizedBox(width: 16),
                              Icon(Icons.logout, color: Color(0xFFE53935)),
                              SizedBox(width: 12),
                              Text('Đăng xuất', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
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
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6D6D6D),
          ),
        ),
      ),
    );
  }

  Widget itemTile({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      dense: true,
      minLeadingWidth: 32,
      onTap: () {
        return;
      },
    );
  }
}
