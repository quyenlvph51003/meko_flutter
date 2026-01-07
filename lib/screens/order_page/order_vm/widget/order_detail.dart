import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/order/order_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import '../order_cubit.dart';
import '../order_state.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderCode;
  final String? productImage;
  final String? productName;

  const OrderDetailPage({
    super.key,
    required this.orderCode,
    this.productImage,
    this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(orderRepository: getIt<OrderRepository>())
        ..loadOrderByCode(orderCode),
      child: _OrderDetailViewWrapper(
        productImage: productImage,
        productName: productName,
      ),
    );
  }
}

/// Wrapper để load thông tin sản phẩm từ post_id nếu cần
class _OrderDetailViewWrapper extends StatefulWidget {
  final String? productImage;
  final String? productName;

  const _OrderDetailViewWrapper({
    this.productImage,
    this.productName,
  });

  @override
  State<_OrderDetailViewWrapper> createState() => _OrderDetailViewWrapperState();
}

class _OrderDetailViewWrapperState extends State<_OrderDetailViewWrapper> {
  String? _loadedProductImage;
  String? _loadedProductName;
  bool _hasTriedLoadingProduct = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await SqliteHelper.getUserSql();
    if (mounted && user != null) {
      setState(() {
        _currentUserId = user.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listenWhen: (prev, curr) =>
          prev.orderDetail?.postId != curr.orderDetail?.postId,
      listener: (context, state) {
        // Nếu không có ảnh từ widget và có postId thì load từ API
        if (widget.productImage == null &&
            state.orderDetail?.postId != null &&
            !_hasTriedLoadingProduct) {
          _loadProductFromPostId(state.orderDetail!.postId!);
        }
      },
      child: BlocBuilder<OrderCubit, OrderState>(
        buildWhen: (prev, curr) =>
            prev.detailStatus != curr.detailStatus ||
            prev.orderDetail != curr.orderDetail,
        builder: (context, state) {
          // Trigger load product nếu cần (cho trường hợp đã có orderDetail)
          if (widget.productImage == null &&
              state.orderDetail?.postId != null &&
              !_hasTriedLoadingProduct) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadProductFromPostId(state.orderDetail!.postId!);
            });
          }

          return OrderDetailView(
            productImage: widget.productImage ?? _loadedProductImage,
            productName: widget.productName ?? _loadedProductName,
            currentUserId: _currentUserId,
          );
        },
      ),
    );
  }

  Future<void> _loadProductFromPostId(int postId) async {
    if (_hasTriedLoadingProduct) return;
    _hasTriedLoadingProduct = true;

    try {
      final postRepo = getIt<PostRepo>();
      final response = await postRepo.getPostDetail(id: postId);
      if (response.success && response.data != null) {
        final post = response.data as ListingItem;
        if (mounted) {
          setState(() {
            _loadedProductImage = post.images.isNotEmpty ? post.images.first : null;
            _loadedProductName = post.title;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading product info: $e');
    }
  }
}

class OrderDetailView extends StatelessWidget {
  final String? productImage;
  final String? productName;
  final int? currentUserId;

  const OrderDetailView({
    super.key,
    this.productImage,
    this.productName,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: BlocBuilder<OrderCubit, OrderState>(
          buildWhen: (prev, curr) =>
              prev.detailStatus != curr.detailStatus ||
              prev.orderDetail != curr.orderDetail,
          builder: (context, state) {
            switch (state.detailStatus) {
              case OrderDetailStatus.loading:
                return _buildLoading();
              case OrderDetailStatus.error:
                return _buildError(context, state.errorMessage);
              case OrderDetailStatus.success:
                if (state.orderDetail == null) {
                  return _buildError(context, 'Không tìm thấy đơn hàng');
                }
                return _buildContent(context, state.orderDetail!);
              default:
                return _buildLoading();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: AppColor.cMain,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Container(
      color: AppColor.cMain,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.white70),
                    const SizedBox(height: 16),
                    Text(
                      message ?? 'Đã có lỗi xảy ra',
                      style: const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      child: Text('Quay lại', style: TextStyle(color: AppColor.cMain)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OrderResponse order) {
    return CustomScrollView(
      slivers: [
        // App Bar với ảnh sản phẩm full header
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColor.cMain,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: order.orderCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Đã sao chép mã đơn hàng'),
                    backgroundColor: Colors.black87,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.copy, color: Colors.white, size: 20),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Ảnh sản phẩm full header hoặc gradient background
                _buildHeaderBackground(),
                // Gradient overlay để text dễ đọc
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: productImage != null && productImage!.isNotEmpty
                          ? [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ]
                          : [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Thông tin đơn hàng ở dưới
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge trạng thái
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.orderStatus),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _translateOrderStatus(order.orderStatus),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Tên sản phẩm (nếu có)
                      if (productName != null && productName!.isNotEmpty)
                        Text(
                          productName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 6),
                      // Mã đơn hàng và ngày tạo
                      Row(
                        children: [
                          const Icon(Icons.receipt_outlined, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            order.orderCode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            _formatDateTime(order.createdAt),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Trạng thái đơn hàng
                _buildStatusSection(order),
                const SizedBox(height: 16),

                // Thông tin người nhận
                _buildReceiverSection(order),
                const SizedBox(height: 16),

                // Thông tin người gửi (nếu có)
                if (order.fromName != null || order.fromPhone != null)
                  ...[
                    _buildSenderSection(order),
                    const SizedBox(height: 16),
                  ],

                // Thông tin vận chuyển
                _buildShippingSection(order),
                const SizedBox(height: 16),

                // Chi tiết thanh toán
                _buildPaymentSection(order),
                const SizedBox(height: 16),

                // Nút xác nhận đơn hàng (chỉ hiển thị cho seller với đơn CREATED)
                if (_isSellerCreatedOrder(order))
                  _buildConfirmOrderButton(context, order),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Kiểm tra có phải seller đang xem đơn CREATED không
  bool _isSellerCreatedOrder(OrderResponse order) {
    return currentUserId != null &&
        currentUserId == order.sellerId &&
        order.orderStatus == 'CREATED';
  }

  Widget _buildConfirmOrderButton(BuildContext context, OrderResponse order) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) =>
          prev.confirmStatus != curr.confirmStatus ||
          prev.confirmingOrderId != curr.confirmingOrderId,
      builder: (context, state) {
        final isConfirming = state.confirmStatus == OrderConfirmStatus.loading &&
            state.confirmingOrderId == order.id;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.cMain.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.check_circle_outline, color: AppColor.cMain, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Xác nhận đơn hàng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Xác nhận để tạo vận đơn GHN và chuyển hàng cho shipper.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isConfirming ? null : () => _onConfirmOrder(context, order),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.cMain,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColor.cMain.withOpacity(0.6),
                  ),
                  child: isConfirming
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Xác nhận đơn hàng',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _onConfirmOrder(BuildContext context, OrderResponse order) async {
    final cubit = context.read<OrderCubit>();
    final success = await cubit.confirmOrder(order.id);

    if (success) {
      Fluttertoast.showToast(
        msg: 'Xác nhận đơn hàng thành công',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      final errorMsg = cubit.state.errorMessage ?? 'Xác nhận đơn hàng thất bại';
      Fluttertoast.showToast(
        msg: errorMsg,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    cubit.resetConfirmStatus();
  }

  Widget _buildHeaderBackground() {
    if (productImage != null && productImage!.isNotEmpty) {
      return Image.network(
        productImage!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildDefaultHeaderBackground(),
      );
    }
    return _buildDefaultHeaderBackground();
  }

  Widget _buildDefaultHeaderBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.cMain,
            AppColor.cMain.withOpacity(0.8),
            const Color(0xFF2E7D32),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Pattern background
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          // Center icon
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    size: 60,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Chi tiết đơn hàng',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(OrderResponse order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.cMain.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.timeline, color: AppColor.cMain, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Trạng thái đơn hàng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Timeline
          _buildTimelineItem(
            icon: Icons.inventory_2_outlined,
            title: 'Đơn hàng',
            subtitle: _getOrderStatusDescription(order.orderStatus),
            status: order.orderStatus,
            isActive: true,
            showLine: true,
          ),
          _buildTimelineItem(
            icon: Icons.payments_outlined,
            title: 'Thanh toán',
            subtitle: _getPaymentDescription(order.paymentStatus, order.paymentMethod),
            status: order.paymentStatus,
            isActive: order.paymentStatus == 'PAID',
            showLine: true,
          ),
          _buildTimelineItem(
            icon: Icons.local_shipping_outlined,
            title: 'Vận chuyển',
            subtitle: _getShippingDescription(order.shippingStatus),
            status: order.shippingStatus,
            isActive: order.shippingStatus != 'PENDING',
            showLine: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required bool isActive,
    required bool showLine,
  }) {
    final color = _getStatusColor(status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isActive ? color.withOpacity(0.15) : Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? color : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isActive ? color : Colors.grey[400],
                  size: 20,
                ),
              ),
              if (showLine)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isActive ? color.withOpacity(0.3) : Colors.grey[200],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: showLine ? 24 : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isActive ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _translateStatus(status),
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverSection(OrderResponse order) {
    final fullAddress = _buildFullAddress(
      order.customerAddress,
      order.toWardName,
      order.toDistrictName,
      order.toProvinceName,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thông tin người nhận',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Họ tên',
            value: order.customerName,
          ),
          const SizedBox(height: 16),

          _buildInfoItem(
            icon: Icons.phone_outlined,
            label: 'Số điện thoại',
            value: order.customerPhone,
            onTap: () {
              Clipboard.setData(ClipboardData(text: order.customerPhone));
            },
          ),
          const SizedBox(height: 16),

          _buildInfoItem(
            icon: Icons.location_on_outlined,
            label: 'Địa chỉ',
            value: fullAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildSenderSection(OrderResponse order) {
    final fullAddress = _buildFullAddress(
      order.fromAddress,
      order.fromWardName,
      order.fromDistrictName,
      order.fromProvinceName,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store, color: Colors.orange, size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'Thông tin người gửi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (order.fromName != null)
            ...[
              _buildInfoItem(
                icon: Icons.person_outline,
                label: 'Họ tên',
                value: order.fromName!,
              ),
              const SizedBox(height: 16),
            ],

          if (order.fromPhone != null)
            ...[
              _buildInfoItem(
                icon: Icons.phone_outlined,
                label: 'Số điện thoại',
                value: order.fromPhone!,
              ),
              const SizedBox(height: 16),
            ],

          if (fullAddress.isNotEmpty)
            _buildInfoItem(
              icon: Icons.location_on_outlined,
              label: 'Địa chỉ',
              value: fullAddress,
            ),
        ],
      ),
    );
  }

  Widget _buildShippingSection(OrderResponse order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.local_shipping, color: Colors.purple, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Thông tin vận chuyển',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.shippingStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _translateShippingStatus(order.shippingStatus),
                  style: TextStyle(
                    color: _getStatusColor(order.shippingStatus),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildInfoItem(
            icon: Icons.business,
            label: 'Đơn vị vận chuyển',
            value: order.shippingProvider,
          ),

          if (order.ghnOrderCode != null && order.ghnOrderCode!.isNotEmpty)
            ...[
              const SizedBox(height: 16),
              _buildInfoItem(
                icon: Icons.qr_code,
                label: 'Mã vận đơn',
                value: order.ghnOrderCode!,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: order.ghnOrderCode!));
                },
              ),
            ],

          if (order.weight != null)
            ...[
              const SizedBox(height: 16),
              _buildInfoItem(
                icon: Icons.fitness_center,
                label: 'Khối lượng',
                value: '${order.weight} gram',
              ),
            ],

          if (order.length != null && order.width != null && order.height != null)
            ...[
              const SizedBox(height: 16),
              _buildInfoItem(
                icon: Icons.straighten,
                label: 'Kích thước',
                value: '${order.length} x ${order.width} x ${order.height} cm',
              ),
            ],

          if (order.requiredNote != null && order.requiredNote!.isNotEmpty)
            ...[
              const SizedBox(height: 16),
              _buildInfoItem(
                icon: Icons.note_outlined,
                label: 'Ghi chú',
                value: order.requiredNote!,
              ),
            ],
        ],
      ),
    );
  }

  Widget _buildPaymentSection(OrderResponse order) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.green, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Chi tiết thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.paymentStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _translatePaymentStatus(order.paymentStatus),
                  style: TextStyle(
                    color: _getStatusColor(order.paymentStatus),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildPaymentRow('Tạm tính', FormatUtils.formatCurrency(order.subtotalAmount)),
          const SizedBox(height: 12),

          _buildPaymentRow('Phí vận chuyển', FormatUtils.formatCurrency(order.shippingFee)),
          const SizedBox(height: 12),

          _buildPaymentRow(
            'Phương thức',
            _translatePaymentMethod(order.paymentMethod),
            valueColor: AppColor.cMain,
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng thanh toán',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                FormatUtils.formatCurrency(order.totalAmount),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (onTap != null)
                      Icon(Icons.copy, size: 16, color: Colors.grey[400]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper functions
  String _buildFullAddress(String? address, String? ward, String? district, String? province) {
    final parts = <String>[];
    if (address != null && address.isNotEmpty) parts.add(address);
    if (ward != null && ward.isNotEmpty) parts.add(ward);
    if (district != null && district.isNotEmpty) parts.add(district);
    if (province != null && province.isNotEmpty) parts.add(province);
    return parts.join(', ');
  }

  String _formatDateTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} - ${time.day.toString().padLeft(2, '0')}/${time.month.toString().padLeft(2, '0')}/${time.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CREATED':
        return Colors.blue;
      case 'CONFIRMED':
        return Colors.orange;
      case 'SHIPPING':
        return Colors.purple;
      case 'COMPLETED':
      case 'DELIVERED':
      case 'PAID':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'UNPAID':
      case 'PENDING':
        return Colors.orange;
      case 'DELIVERING':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'CREATED':
        return 'Đã tạo';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'SHIPPING':
        return 'Đang giao';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'CANCELLED':
        return 'Đã hủy';
      case 'PAID':
        return 'Đã thanh toán';
      case 'UNPAID':
        return 'Chưa thanh toán';
      case 'PENDING':
        return 'Chờ xử lý';
      case 'DELIVERING':
        return 'Đang giao';
      case 'DELIVERED':
        return 'Đã giao';
      default:
        return status;
    }
  }

  String _translateOrderStatus(String status) {
    switch (status) {
      case 'CREATED':
        return 'Chờ xác nhận';
      case 'CONFIRMED':
        return 'Đã xác nhận';
      case 'SHIPPING':
        return 'Đang giao hàng';
      case 'COMPLETED':
        return 'Hoàn thành';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  String _translateShippingStatus(String status) {
    switch (status) {
      case 'PENDING':
        return 'Chờ lấy hàng';
      case 'DELIVERING':
        return 'Đang vận chuyển';
      case 'DELIVERED':
        return 'Đã giao hàng';
      default:
        return status;
    }
  }

  String _translatePaymentStatus(String status) {
    switch (status) {
      case 'PAID':
        return 'Đã thanh toán';
      case 'UNPAID':
        return 'Chưa thanh toán';
      default:
        return status;
    }
  }

  String _translatePaymentMethod(String? method) {
    if (method == null || method.isEmpty) {
      return 'Tiền mặt';
    }
    switch (method) {
      case 'COD':
        return 'Tiền mặt';
      case 'CASH':
        return 'Tiền mặt';
      case 'WALLET':
        return 'Ví Meko';
      case 'BANK':
        return 'Chuyển khoản ngân hàng';
      default:
        return 'Tiền mặt';
    }
  }

  String _getOrderStatusDescription(String status) {
    switch (status) {
      case 'CREATED':
        return 'Đơn hàng đã được tạo, chờ người bán xác nhận';
      case 'CONFIRMED':
        return 'Người bán đã xác nhận đơn hàng';
      case 'SHIPPING':
        return 'Đơn hàng đang được vận chuyển';
      case 'COMPLETED':
        return 'Đơn hàng đã hoàn thành';
      case 'CANCELLED':
        return 'Đơn hàng đã bị hủy';
      default:
        return 'Đang xử lý';
    }
  }

  String _getPaymentDescription(String paymentStatus, String? paymentMethod) {
    if (paymentStatus == 'PAID') {
      return 'Đã thanh toán thành công';
    }
    if (paymentMethod == 'COD' || paymentMethod == 'CASH' || paymentMethod == null || paymentMethod.isEmpty) {
      return 'Thanh toán tiền mặt khi nhận hàng';
    }
    return 'Chờ thanh toán';
  }

  String _getShippingDescription(String status) {
    switch (status) {
      case 'PENDING':
        return 'Chờ người bán chuẩn bị hàng';
      case 'DELIVERING':
        return 'Shipper đang vận chuyển đơn hàng';
      case 'DELIVERED':
        return 'Đã giao hàng thành công';
      default:
        return 'Đang chuẩn bị';
    }
  }
}
