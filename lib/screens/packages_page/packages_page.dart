import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/package/package_model.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/repository/package/package_repository.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';
import 'package:meko_project/screens/packages_page/packages_vm/packages_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PackagesCubit _cubit;
  bool _argsHandled = false;

  @override
  void initState() {
    super.initState();
    _cubit = PackagesCubit(packageRepository: getIt<PackageRepository>(), paymentRepo: getIt<PaymentRepo>())..initCubit();

    _tabController = TabController(length: 2, vsync: this, initialIndex: _cubit.state.selectedIndex);

    _tabController.addListener(() {
      if (_tabController.index != _tabController.previousIndex) {
        _cubit.changeSelectedIndex(_tabController.index);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argsHandled) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['initialIndex'] is int) {
      final int idx = args['initialIndex'] as int;
      if (idx >= 0 && idx < _tabController.length) {
        _tabController.animateTo(idx);
        _cubit.changeSelectedIndex(idx);
      }
    }
    _argsHandled = true;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<PackagesCubit, PackagesState>(
        builder: (context, state) {
          // Đồng bộ TabController với Cubit state
          if (_tabController.index != state.selectedIndex) {
            _tabController.animateTo(state.selectedIndex);
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Gói đăng bài'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  //check nếu navigate từ create_post_page sang
                  Navigator.of(context).pop(true);
                },
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: AppColor.cMain,
                dividerColor: Colors.grey,
                indicatorColor: AppColor.cMain,
                tabs: const [
                  Tab(text: 'Đã mua'),
                  Tab(text: 'Đang bán'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(
                  state.userPayments,
                  state.packages,
                  emptyText: 'Bạn chưa mua gói nào',
                  isLoading: state.isLoading,
                  isUserPayment: true,
                ),
                _buildListView(
                  state.userPayments,
                  state.packages,
                  emptyText: 'Không có gói đang bán',
                  isLoading: state.isLoading,
                  isUserPayment: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(
    List<UserPaymentModel> items,
    List<PackageModel> itemPackages, {
    required String emptyText,
    required bool isLoading,
    required bool isUserPayment,
  }) {
    if (isLoading) {
      return Center(child: AppLoader());
    }
    if (items.isEmpty && isUserPayment) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(emptyText, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
        ],
      );
    }
    if (itemPackages.isEmpty && !isUserPayment) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(emptyText, style: TextStyle(color: Colors.grey[700], fontSize: 16)),
        ],
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: isUserPayment ? items.length : itemPackages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        // final item = items[index];
        return _PackageTile(
          item: isUserPayment ? items[index] : null,
          isUserPayment: isUserPayment,
          itemPackage: isUserPayment ? null : itemPackages[index],
        );
      },
    );
  }
}

class _PackageTile extends StatelessWidget {
  UserPaymentModel? item;
  PackageModel? itemPackage;
  final bool isUserPayment;
  _PackageTile({required this.item, required this.isUserPayment, this.itemPackage});

  @override
  Widget build(BuildContext context) {
    DateTime? expiredAt;
    if (isUserPayment) {
      expiredAt = DateTime.tryParse(item?.expiredAt ?? '');
    }
    final isExpired = expiredAt?.isBefore(DateTime.now()) ?? false;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: isExpired ? Colors.grey[200] : Colors.white,
      elevation: 1,
      child: InkWell(
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(isUserPayment ? (item?.packageName ?? '') : (itemPackage?.name ?? '')),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text(
                        'Giá: ${isUserPayment ? FormatUtils.formatCurrency(double.tryParse(item?.amount ?? '0') ?? 0) : 'Miễn phí khi đăng ký lần đầu'}',
                      ),
                      const SizedBox(height: 8),
                      Text(isUserPayment ? 'Mã GD: #${item?.transactionCode ?? ''}' : 'Mô tả: ${itemPackage?.description ?? ''}'),
                      const SizedBox(height: 8),
                      Text(
                        isUserPayment
                            ? '${isExpired ? 'Đã hết hạn' : 'Hết hạn'}: ${FormatUtils.formatDateNoMinitues(DateTime.tryParse(item?.expiredAt ?? '') ?? DateTime.now())}'
                            : 'Hạn sử dụng: ${itemPackage?.expiredAt} ngày',
                      ),
                      const SizedBox(height: 8),
                      isUserPayment
                          ? Text('Đã dùng: ${(item?.usageLimit ?? 0) - (item?.usageRemaining ?? 0)}  •  Còn: ${item?.usageRemaining ?? 0}')
                          : Text('Sử dụng: ${itemPackage?.durationDays ?? 0} ngày khi đăng bài  •  Lượt: ${itemPackage?.usageLimit ?? 0}'),
                      Visibility(visible: isUserPayment, child: const SizedBox(height: 8)),
                      Visibility(
                        visible: isUserPayment,
                        child: Text('Đã mua: ${FormatUtils.formatDateNoMinitues(DateTime.tryParse(item?.createdAt ?? '') ?? DateTime.now())}'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Đóng', style: TextStyle(fontSize: 15, color: Colors.grey)),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                  if (!isUserPayment && (itemPackage?.status ?? 0) == 1)
                    ElevatedButton(
                      child: const Text('Mua gói', style: TextStyle(fontSize: 15, color: AppColor.cMain)),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pushNamed(
                          AppRouterPaths.purchasePackagePage,
                          arguments: {'packageId': itemPackage?.id, 'price': itemPackage?.price, 'title': itemPackage?.name},
                        );
                      },
                    ),
                ],
              );
            },
          );
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
                      isUserPayment ? '#${item?.transactionCode ?? ''}' : '${itemPackage?.name ?? ''}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 12),
                  (!isUserPayment && itemPackage?.status == 0)
                      ? Text(
                          'Mặc định',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                        )
                      : Text(
                          isUserPayment
                              ? '${FormatUtils.formatCurrency(double.tryParse(item?.amount ?? '0') ?? 0)}'
                              : '${FormatUtils.formatCurrency(double.tryParse(itemPackage?.price ?? '0') ?? 0)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                        ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isUserPayment ? item?.packageName ?? '' : itemPackage?.description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.event, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isUserPayment
                          ? 'Hết hạn: ${FormatUtils.formatDateNoMinitues(DateTime.tryParse(item?.expiredAt ?? '') ?? DateTime.now())}'
                          : 'Hạn sử dụng: ${itemPackage?.expiredAt} ngày',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  isUserPayment
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Text('Đã dùng: ${(item?.usageLimit ?? 0) - (item?.usageRemaining ?? 0)}', style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 8),
                              Text('Còn: ${item?.usageRemaining}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Text('Sử dụng: ${itemPackage?.durationDays} ngày', style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 8),
                              Text('Lượt: ${itemPackage?.usageLimit}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),

                  // If this is a package in the selling tab and status == 1 show buy button
                ],
              ),
              if (!isUserPayment && (itemPackage?.status ?? 0) == 1) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRouterPaths.purchasePackagePage,
                        arguments: {'packageId': itemPackage?.id, 'price': itemPackage?.price, 'title': itemPackage?.name},
                      );
                    },
                    child: const Text('Mua gói', style: TextStyle(fontSize: 16, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: AppColor.cMain,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
