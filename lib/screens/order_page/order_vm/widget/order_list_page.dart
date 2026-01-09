import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/repository/order/order_repo.dart';
import 'package:meko_project/screens/order_page/order_vm/order_cubit.dart';
import 'package:meko_project/screens/order_page/order_vm/order_state.dart';
import 'package:meko_project/screens/order_page/widgets/confirm_order_page.dart';
import 'package:meko_project/screens/order_page/widgets/update_order_page.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';

import 'order_detail.dart';




class OrderListPage extends StatelessWidget {
  /// Tab mặc định: 0 = Đã mua, 1 = Đang bán
  final int initialTab;

  const OrderListPage({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(orderRepository: getIt<OrderRepository>()),
      child: _OrderListView(initialTab: initialTab),
    );
  }
}

class _OrderListView extends StatefulWidget {
  final int initialTab;

  const _OrderListView({required this.initialTab});

  @override
  State<_OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<_OrderListView> with SingleTickerProviderStateMixin {
  late TabController _mainTabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    _mainTabController.addListener(_onMainTabChanged);
    _scrollController.addListener(_onScroll);

    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    final cubit = context.read<OrderCubit>();
    await cubit.initializeForList();
    cubit.loadOrders(
      filterType: widget.initialTab == 0 ? OrderFilterType.buying : OrderFilterType.selling,
    );
  }

  void _onMainTabChanged() {
    if (_mainTabController.indexIsChanging) return;
    final filterType = _mainTabController.index == 0
        ? OrderFilterType.buying
        : OrderFilterType.selling;
    context.read<OrderCubit>().changeFilterType(filterType);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<OrderCubit>().loadMoreOrders();
    }
  }

  @override
  void dispose() {
    _mainTabController.removeListener(_onMainTabChanged);
    _mainTabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Đơn hàng của tôi',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _mainTabController,
              indicatorColor: AppColor.cMain,
              indicatorWeight: 3,
              labelColor: AppColor.cMain,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              tabs: const [
                Tab(text: 'Đã mua'),
                Tab(text: 'Đang bán'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const _StatusFilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<OrderCubit, OrderState>(
              buildWhen: (prev, curr) =>
              prev.listStatus != curr.listStatus ||
                  prev.orders != curr.orders,
              builder: (context, state) {
                switch (state.listStatus) {
                  case OrderListStatus.initial:
                  case OrderListStatus.loading:
                    return const _LoadingView();
                  case OrderListStatus.error:
                    return _ErrorView(message: state.errorMessage);
                  case OrderListStatus.success:
                  case OrderListStatus.loadingMore:
                    if (state.orders.isEmpty) {
                      return const _EmptyView();
                    }
                    return _OrderListContent(
                      orders: state.orders,
                      scrollController: _scrollController,
                      isLoadingMore: state.listStatus == OrderListStatus.loadingMore,
                      hasMore: state.hasMore,
                      filterType: state.filterType,
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== STATUS FILTER CHIPS ====================

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => prev.statusFilter != curr.statusFilter,
      builder: (context, state) {
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: OrderStatusFilter.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = OrderStatusFilter.values[index];
              final isSelected = state.statusFilter == filter;
              return GestureDetector(
                onTap: () => context.read<OrderCubit>().changeStatusFilter(filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.cMain : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColor.cMain : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    filter.displayName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
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

// ==================== ORDER LIST CONTENT ====================

class _OrderListContent extends StatelessWidget {
  final List<OrderResponse> orders;
  final ScrollController scrollController;
  final bool isLoadingMore;
  final bool hasMore;
  final OrderFilterType filterType;

  const _OrderListContent({
    required this.orders,
    required this.scrollController,
    required this.isLoadingMore,
    required this.hasMore,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<OrderCubit>().refreshOrders(),
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: orders.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= orders.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OrderCard(order: orders[index], filterType: filterType),
          );
        },
      ),
    );
  }
}

// ==================== ORDER CARD ====================

class _OrderCard extends StatelessWidget {
  final OrderResponse order;
  final OrderFilterType filterType;

  const _OrderCard({required this.order, required this.filterType});

  /// Kiểm tra có phải seller đang xem đơn CREATED không
  bool get _isSellerCreatedOrder =>
      filterType == OrderFilterType.selling && order.orderStatus == 'CREATED';

  /// Kiểm tra có phải buyer đang xem đơn CREATED không (chờ xác nhận)
  bool get _isBuyerCreatedOrder =>
      filterType == OrderFilterType.buying && order.orderStatus == 'CREATED';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.receipt_outlined, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      order.orderCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _buildStatusBadge(order.orderStatus),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.cMain.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.person_outline, size: 20, color: AppColor.cMain),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customerName,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              order.customerPhone,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _buildFullAddress(order),
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            FormatUtils.formatCurrency(order.totalAmount),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildShippingBadge(order.shippingStatus),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColor.cMain.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppColor.cMain,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Confirm button for seller's CREATED orders
                  if (_isSellerCreatedOrder) ...[
                    const SizedBox(height: 12),
                    _buildConfirmButton(context),
                  ],

                  // Cancel and Edit buttons for buyer's CREATED orders
                  if (_isBuyerCreatedOrder) ...[
                    const SizedBox(height: 12),
                    _buildBuyerActionButtons(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onConfirmOrder(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.cMain,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Xác nhận đơn hàng',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

  Future<void> _onConfirmOrder(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmOrderPage(order: order),
      ),
    );

    // Nếu xác nhận thành công thì refresh danh sách
    if (result == true) {
      context.read<OrderCubit>().refreshOrders();
    }
  }

  Widget _buildBuyerActionButtons(BuildContext context) {
    return Row(
      children: [
        // Nút Sửa đơn hàng
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _onEditOrder(context),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Sửa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.cMain,
              side: BorderSide(color: AppColor.cMain),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Nút Hủy đơn hàng
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _onCancelOrder(context),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text('Hủy đơn'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onEditOrder(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateOrderPage(order: order),
      ),
    );

    if (result == true) {
      context.read<OrderCubit>().refreshOrders();
    }
  }

  Future<void> _onCancelOrder(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận hủy đơn'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final orderRepo = getIt<OrderRepository>();
      final response = await orderRepo.cancelOrder(order.id);

      if (response.success) {
        Fluttertoast.showToast(
          msg: 'Hủy đơn hàng thành công',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        context.read<OrderCubit>().refreshOrders();
      } else {
        Fluttertoast.showToast(
          msg: response.message ?? 'Hủy đơn hàng thất bại',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String text;

    switch (status) {
      case 'CREATED':
        bgColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        text = 'Chờ xác nhận';
        break;
      case 'CONFIRMED':
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = 'Đã xác nhận';
        break;
      case 'SHIPPING':
        bgColor = Colors.purple.withOpacity(0.1);
        textColor = Colors.purple;
        text = 'Đang giao';
        break;
      case 'COMPLETED':
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = 'Hoàn thành';
        break;
      case 'CANCELLED':
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        text = 'Đã hủy';
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildShippingBadge(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'PENDING':
        icon = Icons.hourglass_empty;
        color = Colors.orange;
        break;
      case 'DELIVERING':
        icon = Icons.local_shipping;
        color = Colors.blue;
        break;
      case 'DELIVERED':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(icon, size: 20, color: color);
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailPage(
          orderCode: order.orderCode,
          productImage: order.productImage,
          productName: order.productName,
        ),
      ),
    );
  }

  String _buildFullAddress(OrderResponse order) {
    final parts = <String>[];
    if (order.customerAddress.isNotEmpty) parts.add(order.customerAddress);
    if (order.toWardName != null && order.toWardName!.isNotEmpty) {
      parts.add(order.toWardName!);
    }
    if (order.toDistrictName != null && order.toDistrictName!.isNotEmpty) {
      parts.add(order.toDistrictName!);
    }
    if (order.toProvinceName != null && order.toProvinceName!.isNotEmpty) {
      parts.add(order.toProvinceName!);
    }
    return parts.join(', ');
  }
}

// ==================== LOADING, ERROR, EMPTY VIEWS ====================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String? message;

  const _ErrorView({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message ?? 'Đã có lỗi xảy ra',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<OrderCubit>().refreshOrders(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.cMain,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Chưa có đơn hàng nào',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy mua sắm để có đơn hàng đầu tiên',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}