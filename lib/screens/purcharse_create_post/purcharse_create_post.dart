import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/purcharse_create_post/vm/purcharse_create_post_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';

class PurcharseCreatePost extends StatefulWidget {
  const PurcharseCreatePost({super.key});

  @override
  State<PurcharseCreatePost> createState() => _PurcharseCreatePostState();
}

class _PurcharseCreatePostState extends State<PurcharseCreatePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.cMain,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chọn gói đăng bài', style: TextStyle(color: Colors.white)),
      ),
      body: BlocProvider(
        create: (context) => PurcharseCreatePostCubit(paymentRepo: getIt<PaymentRepo>())..initCubit(),
        child: BlocBuilder<PurcharseCreatePostCubit, PurcharseCreatePostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: AppLoader());
            }
            if (state.userPayments.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text('Bạn chưa sở hữu gói đăng nào', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.cMain,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRouterPaths.packagePages, arguments: {'initialIndex': 1});
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Mua gói',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: state.userPayments.length,
                    itemBuilder: (context, index) {
                      return Material(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        elevation: 1,
                        child: InkWell(
                          onLongPress: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: Text(state.userPayments[index].packageName ?? ''),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Text('Giá: ${FormatUtils.formatCurrency(double.tryParse(state.userPayments[index].amount ?? '0') ?? 0)}'),
                                        const SizedBox(height: 8),
                                        Text('Mã GD: #${state.userPayments[index].transactionCode ?? ''}'),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Hết hạn: ${FormatUtils.formatDateNoMinitues(DateTime.tryParse(state.userPayments[index].expiredAt ?? '') ?? DateTime.now())}',
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Đã dùng: ${(state.userPayments[index].usageLimit ?? 0) - (state.userPayments[index].usageRemaining ?? 0)}  •  Còn: ${state.userPayments[index].usageRemaining ?? 0}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Đóng', style: TextStyle(fontSize: 15, color: Colors.grey)),
                                      onPressed: () => Navigator.of(ctx).pop(),
                                    ),
                                    TextButton(
                                      child: const Text('Chọn', style: TextStyle(fontSize: 15, color: AppColor.cMain)),
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pop(state.userPayments[index]);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          onTap: () {
                            Navigator.of(context).pop(state.userPayments[index]);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        state.userPayments[index].packageName ?? '',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '${FormatUtils.formatCurrency(double.tryParse(state.userPayments[index].amount ?? '0') ?? 0)}',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 8),
                                // Text(
                                //   state.userPayments[index].packageName ?? '',
                                //   maxLines: 2,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: const TextStyle(color: Colors.black87),
                                // ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.event, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Hết hạn: ${FormatUtils.formatDateNoMinitues(DateTime.tryParse(state.userPayments[index].expiredAt ?? '') ?? DateTime.now())}',
                                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Đã dùng: ${(state.userPayments[index].usageLimit ?? 0) - (state.userPayments[index].usageRemaining ?? 0)}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Còn: ${state.userPayments[index].usageRemaining}',
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // If this is a package in the selling tab and status == 1 show buy button
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.cMain,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        final result = await Navigator.of(context).pushNamed(AppRouterPaths.packagePages, arguments: {'initialIndex': 1});
                        if (result == true) {
                          context.read<PurcharseCreatePostCubit>().initCubit();
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Mua gói',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
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
