// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meko_project/models/body/order/order_request.dart';
// import 'package:meko_project/models/body/post/listing_item_model.dart';
// import 'package:meko_project/repository/order/order_repo.dart';
// import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
//
// import 'order_state.dart';
//
// class OrderCubit extends Cubit<OrderState> {
//   final OrderRepository orderRepository;
//
//   OrderCubit({
//     ListingItem? item,
//     required this.orderRepository,
//   }) : super(OrderState(item: item));
//
//   Future<void> loadUser() async {
//     final user = await SqliteHelper.getUserSql();
//     if (user == null) return;
//
//     emit(state.copyWith(
//       name: user.username ?? '',
//       address: user.addressName ?? '',
//     ));
//   }
//
//   void updateName(String value) {
//     if (state.name == value) return;
//     emit(state.copyWith(name: value));
//   }
//
//   void updatePhone(String value) {
//     if (state.phone == value) return;
//     emit(state.copyWith(phone: value));
//   }
//
//   void updateAddress(String value) {
//     if (state.address == value) return;
//     emit(state.copyWith(address: value));
//   }
//
//   void updateNote(String value) {
//     if (state.note == value) return;
//     emit(state.copyWith(note: value));
//   }
//
//   void updatePaymentMethod(int value) {
//     if (state.paymentMethod == value) return;
//     emit(state.copyWith(paymentMethod: value));
//   }
//
//   void updateShippingAddress({
//     required int provinceId,
//     required int districtId,
//     required String wardCode,
//     required String address,
//   }) {
//     emit(state.copyWith(
//       toProvinceId: provinceId,
//       toDistrictId: districtId,
//       toWardCode: wardCode,
//       address: address,
//     ));
//   }
//
//   void updateShippingFee(double fee) {
//     emit(state.copyWith(shippingFee: fee));
//   }
//
//   void increaseQuantity() {
//     emit(state.copyWith(quantity: state.quantity + 1));
//   }
//
//   void decreaseQuantity() {
//     if (state.quantity <= 1) return;
//     emit(state.copyWith(quantity: state.quantity - 1));
//   }
//
//   Future<bool> submitOrder() async {
//     if (state.name.isEmpty) {
//       emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng nhập họ tên'));
//       return false;
//     }
//     if (state.phone.isEmpty) {
//       emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng nhập số điện thoại'));
//       return false;
//     }
//     if (state.address.isEmpty) {
//       emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng nhập địa chỉ'));
//       return false;
//     }
//
//     emit(state.copyWith(status: OrderFormStatus.loading));
//
//     try {
//       final user = await SqliteHelper.getUserSql();
//
//       final request = OrderRequest(
//         sellerId: state.item?.userPostId ?? 0,
//         customerId: user?.id ?? 0,
//         customerName: state.name,
//         customerPhone: state.phone,
//         customerAddress: state.address,
//         subtotalAmount: state.subtotalPrice.toInt(),
//         shippingFee: state.shippingFee.toInt(),
//         totalAmount: state.totalPrice.toInt(),
//         toProvinceId: state.toProvinceId ?? 202,
//         toDistrictId: state.toDistrictId ?? 1488,
//         toWardCode: state.toWardCode ?? '21211',
//       );
//
//       final response = await orderRepository.createOrder(request);
//
//       if (response.success && response.data != null) {
//         emit(state.copyWith(
//           status: OrderFormStatus.success,
//           createdOrder: response.data,
//         ));
//         return true;
//       } else {
//         emit(state.copyWith(
//           status: OrderFormStatus.error,
//           errorMessage: response.message ?? 'Tạo đơn hàng thất bại',
//         ));
//         return false;
//       }
//     } catch (e) {
//       emit(state.copyWith(status: OrderFormStatus.error, errorMessage: e.toString()));
//       return false;
//     }
//   }
//
//   Future<void> loadOrderByCode(String orderCode) async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     emit(state.copyWith(detailStatus: OrderDetailStatus.loading));
//
//     final response = await orderRepository.getOrderByCode(orderCode);
//
//     if (response.success && response.data != null) {
//       emit(state.copyWith(
//         detailStatus: OrderDetailStatus.success,
//         orderDetail: response.data,
//       ));
//     } else {
//       emit(state.copyWith(
//         detailStatus: OrderDetailStatus.error,
//         errorMessage: response.message ?? 'Không tìm thấy đơn hàng',
//       ));
//     }
//   }
//
//   void resetStatus() {
//     emit(state.copyWith(status: OrderFormStatus.initial, errorMessage: null));
//   }
//
//   void resetDetailStatus() {
//     emit(state.copyWith(detailStatus: OrderDetailStatus.initial, orderDetail: null));
//   }
// }



import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/order/order_request.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/order/order_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository orderRepository;

  OrderCubit({
    ListingItem? item,
    required this.orderRepository,
  }) : super(OrderState(item: item));

  // ==================== FORM - TẠO ĐƠN ====================

  Future<void> loadUser() async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) return;

    emit(state.copyWith(
      name: user.username ?? '',
      address: user.addressName ?? '',
      userId: user.id,
    ));
  }

  void updateName(String value) {
    if (state.name == value) return;
    emit(state.copyWith(name: value));
  }

  void updatePhone(String value) {
    if (state.phone == value) return;
    emit(state.copyWith(phone: value));
  }

  void updateAddress(String value) {
    if (state.address == value) return;
    emit(state.copyWith(address: value));
  }

  void updateAddressDetail(String value) {
    if (state.addressDetail == value) return;
    emit(state.copyWith(addressDetail: value));
  }

  void updateNote(String value) {
    if (state.note == value) return;
    emit(state.copyWith(note: value));
  }

  void updatePaymentMethod(int value) {
    if (state.paymentMethod == value) return;
    emit(state.copyWith(paymentMethod: value));
  }

  void updateShippingAddress({
    required int provinceId,
    required int districtId,
    required String wardCode,
    required String address,
  }) {
    emit(state.copyWith(
      toProvinceId: provinceId,
      toDistrictId: districtId,
      toWardCode: wardCode,
      address: address,
    ));
  }

  void updateShippingFee(double fee) {
    emit(state.copyWith(shippingFee: fee));
  }

  void increaseQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decreaseQuantity() {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }

  Future<bool> submitOrder() async {
    if (state.name.isEmpty) {
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng nhập họ tên'));
      return false;
    }
    if (state.phone.isEmpty) {
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng nhập số điện thoại'));
      return false;
    }
    if (state.address.isEmpty) {
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng chọn Tỉnh/Huyện/Xã'));
      return false;
    }
    if (state.toProvinceId == null || state.toDistrictId == null || state.toWardCode == null) {
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng chọn đầy đủ địa chỉ'));
      return false;
    }

    emit(state.copyWith(status: OrderFormStatus.loading));

    try {
      final user = await SqliteHelper.getUserSql();

      final request = OrderRequest(
        sellerId: state.item?.userPostId ?? 0,
        customerId: user?.id ?? 0,
        customerName: state.name,
        customerPhone: state.phone,
        customerAddress: state.fullCustomerAddress,
        subtotalAmount: state.subtotalPrice.toInt(),
        shippingFee: state.shippingFee.toInt(),
        totalAmount: state.totalPrice.toInt(),
        toProvinceId: state.toProvinceId!,
        toDistrictId: state.toDistrictId!,
        toWardCode: state.toWardCode!,
        postId: state.item?.id,
      );

      final response = await orderRepository.createOrder(request);

      if (response.success && response.data != null) {
        emit(state.copyWith(
          status: OrderFormStatus.success,
          createdOrder: response.data,
        ));
        return true;
      } else {
        emit(state.copyWith(
          status: OrderFormStatus.error,
          errorMessage: response.message ?? 'Tạo đơn hàng thất bại',
        ));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: e.toString()));
      return false;
    }
  }

  void resetStatus() {
    emit(state.copyWith(status: OrderFormStatus.initial, errorMessage: null));
  }

  // ==================== DETAIL - CHI TIẾT ĐƠN ====================

  Future<void> loadOrderByCode(String orderCode) async {
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(detailStatus: OrderDetailStatus.loading));

    final response = await orderRepository.getOrderByCode(orderCode);

    if (response.success && response.data != null) {
      emit(state.copyWith(
        detailStatus: OrderDetailStatus.success,
        orderDetail: response.data,
      ));
    } else {
      emit(state.copyWith(
        detailStatus: OrderDetailStatus.error,
        errorMessage: response.message ?? 'Không tìm thấy đơn hàng',
      ));
    }
  }

  void resetDetailStatus() {
    emit(state.copyWith(detailStatus: OrderDetailStatus.initial, orderDetail: null));
  }

  // ==================== LIST - DANH SÁCH ĐƠN ====================

  /// Khởi tạo userId cho list
  Future<void> initializeForList() async {
    final user = await SqliteHelper.getUserSql();
    if (user != null) {
      emit(state.copyWith(userId: user.id));
    }
  }

  /// Load danh sách đơn hàng (refresh)
  Future<void> loadOrders({
    OrderFilterType? filterType,
    OrderStatusFilter? statusFilter,
  }) async {
    final newFilterType = filterType ?? state.filterType;
    final newStatusFilter = statusFilter ?? state.statusFilter;

    emit(state.copyWith(
      listStatus: OrderListStatus.loading,
      filterType: newFilterType,
      statusFilter: newStatusFilter,
      orders: [],
      currentPage: 0,
      hasMore: true,
    ));

    await _fetchOrders(
      page: 0,
      filterType: newFilterType,
      statusFilter: newStatusFilter,
      isLoadMore: false,
    );
  }

  /// Load thêm đơn hàng (pagination)
  Future<void> loadMoreOrders() async {
    if (!state.hasMore || state.listStatus == OrderListStatus.loadingMore) return;

    emit(state.copyWith(listStatus: OrderListStatus.loadingMore));

    await _fetchOrders(
      page: state.currentPage + 1,
      filterType: state.filterType,
      statusFilter: state.statusFilter,
      isLoadMore: true,
    );
  }

  /// Fetch orders from API
  Future<void> _fetchOrders({
    required int page,
    required OrderFilterType filterType,
    required OrderStatusFilter statusFilter,
    required bool isLoadMore,
  }) async {
    try {
      final userId = state.userId;
      if (userId == null) {
        emit(state.copyWith(
          listStatus: OrderListStatus.error,
          errorMessage: 'Vui lòng đăng nhập để xem đơn hàng',
        ));
        return;
      }

      // Determine seller_id or customer_id based on filter type
      int? sellerId;
      int? customerId;

      switch (filterType) {
        case OrderFilterType.selling:
          sellerId = userId;
          break;
        case OrderFilterType.buying:
          customerId = userId;
          break;
        case OrderFilterType.all:
          customerId = userId; // Default to buying view
          break;
      }

      final response = await orderRepository.getOrders(
        sellerId: sellerId,
        customerId: customerId,
        orderStatus: statusFilter.apiValue,
        page: page,
        limit: 20,
      );

      if (response.success && response.data != null) {
        final newOrders = response.data!.orders;
        final allOrders = isLoadMore
            ? [...state.orders, ...newOrders]
            : newOrders;

        emit(state.copyWith(
          listStatus: OrderListStatus.success,
          orders: allOrders,
          currentPage: page,
          hasMore: response.data!.hasMore,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          listStatus: OrderListStatus.error,
          errorMessage: response.message ?? 'Không thể tải danh sách đơn hàng',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        listStatus: OrderListStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Đổi filter type (Đang bán / Đã mua)
  void changeFilterType(OrderFilterType type) {
    if (type == state.filterType) return;
    loadOrders(filterType: type, statusFilter: OrderStatusFilter.all);
  }

  /// Đổi status filter
  void changeStatusFilter(OrderStatusFilter status) {
    if (status == state.statusFilter) return;
    loadOrders(statusFilter: status);
  }

  /// Refresh danh sách
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  /// Reset list state
  void resetListStatus() {
    emit(state.copyWith(
      listStatus: OrderListStatus.initial,
      orders: [],
      currentPage: 0,
      hasMore: true,
    ));
  }

  // ==================== CONFIRM ORDER (SELLER) ====================

  /// Xác nhận đơn hàng - Tạo vận đơn GHN
  Future<bool> confirmOrder(int orderId) async {
    emit(state.copyWith(
      confirmStatus: OrderConfirmStatus.loading,
      confirmingOrderId: orderId,
    ));

    try {
      final response = await orderRepository.confirmOrderGHN(orderId);

      if (response.success) {
        // Cập nhật order trong list nếu có
        final updatedOrders = state.orders.map((order) {
          if (order.id == orderId && response.data != null) {
            return response.data!;
          }
          return order;
        }).toList();

        // Cập nhật orderDetail nếu đang xem detail của order này
        OrderResponse? updatedOrderDetail = state.orderDetail;
        if (state.orderDetail?.id == orderId && response.data != null) {
          updatedOrderDetail = response.data;
        }

        emit(state.copyWith(
          confirmStatus: OrderConfirmStatus.success,
          confirmingOrderId: null,
          orders: updatedOrders,
          orderDetail: updatedOrderDetail,
        ));
        return true;
      } else {
        emit(state.copyWith(
          confirmStatus: OrderConfirmStatus.error,
          confirmingOrderId: null,
          errorMessage: response.message ?? 'Xác nhận đơn hàng thất bại',
        ));
        return false;
      }
    } catch (e) {
      emit(state.copyWith(
        confirmStatus: OrderConfirmStatus.error,
        confirmingOrderId: null,
        errorMessage: e.toString(),
      ));
      return false;
    }
  }

  /// Reset confirm status
  void resetConfirmStatus() {
    emit(state.copyWith(
      confirmStatus: OrderConfirmStatus.initial,
      confirmingOrderId: null,
    ));
  }
}