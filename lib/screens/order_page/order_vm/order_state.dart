// import 'package:equatable/equatable.dart';
// import 'package:meko_project/models/body/order/order_response.dart';
// import 'package:meko_project/models/body/post/listing_item_model.dart';
//
// enum OrderFormStatus { initial, loading, success, error }
// enum OrderDetailStatus { initial, loading, success, error }
//
// class OrderState extends Equatable {
//   final ListingItem? item;
//   final String name;
//   final String phone;
//   final String address;
//   final String note;
//   final int quantity;
//   final int paymentMethod;
//   final int? toProvinceId;
//   final int? toDistrictId;
//   final String? toWardCode;
//   final double shippingFee;
//   final OrderFormStatus status;
//   final String? errorMessage;
//   final OrderResponse? createdOrder;
//   final OrderDetailStatus detailStatus;
//   final OrderResponse? orderDetail;
//
//   const OrderState({
//     this.item,
//     this.name = '',
//     this.phone = '',
//     this.address = '',
//     this.note = '',
//     this.quantity = 1,
//     this.paymentMethod = 0,
//     this.toProvinceId,
//     this.toDistrictId,
//     this.toWardCode,
//     this.shippingFee = 0,
//     this.status = OrderFormStatus.initial,
//     this.errorMessage,
//     this.createdOrder,
//     this.detailStatus = OrderDetailStatus.initial,
//     this.orderDetail,
//   });
//
//   double get unitPrice => double.tryParse(item?.price ?? '0') ?? 0;
//   double get subtotalPrice => unitPrice * quantity;
//   double get totalPrice => subtotalPrice + shippingFee;
//   bool get isValid => name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty;
//
//   OrderState copyWith({
//     ListingItem? item,
//     String? name,
//     String? phone,
//     String? address,
//     String? note,
//     int? quantity,
//     int? paymentMethod,
//     int? toProvinceId,
//     int? toDistrictId,
//     String? toWardCode,
//     double? shippingFee,
//     OrderFormStatus? status,
//     String? errorMessage,
//     OrderResponse? createdOrder,
//     OrderDetailStatus? detailStatus,
//     OrderResponse? orderDetail,
//   }) {
//     return OrderState(
//       item: item ?? this.item,
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       address: address ?? this.address,
//       note: note ?? this.note,
//       quantity: quantity ?? this.quantity,
//       paymentMethod: paymentMethod ?? this.paymentMethod,
//       toProvinceId: toProvinceId ?? this.toProvinceId,
//       toDistrictId: toDistrictId ?? this.toDistrictId,
//       toWardCode: toWardCode ?? this.toWardCode,
//       shippingFee: shippingFee ?? this.shippingFee,
//       status: status ?? this.status,
//       errorMessage: errorMessage,
//       createdOrder: createdOrder ?? this.createdOrder,
//       detailStatus: detailStatus ?? this.detailStatus,
//       orderDetail: orderDetail ?? this.orderDetail,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     item, name, phone, address, note, quantity, paymentMethod,
//     toProvinceId, toDistrictId, toWardCode, shippingFee,
//     status, errorMessage, createdOrder, detailStatus, orderDetail,
//   ];
// }



import 'package:equatable/equatable.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';

// ==================== ENUMS ====================

enum OrderFormStatus { initial, loading, success, error }
enum OrderDetailStatus { initial, loading, success, error }
enum OrderListStatus { initial, loading, success, error, loadingMore }
enum OrderConfirmStatus { initial, loading, success, error }

/// Filter theo vai trò
enum OrderFilterType {
  all,      // Tất cả
  selling,  // Đơn đang bán (seller_id)
  buying,   // Đơn đã mua (customer_id)
}

/// Filter theo trạng thái đơn hàng
enum OrderStatusFilter {
  all,        // Tất cả
  created,    // Mới tạo
  confirmed,  // Đã xác nhận
  shipping,   // Đang giao
  completed,  // Hoàn thành
  cancelled,  // Đã hủy
}

extension OrderStatusFilterExt on OrderStatusFilter {
  String? get apiValue {
    switch (this) {
      case OrderStatusFilter.all:
        return null;
      case OrderStatusFilter.created:
        return 'CREATED';
      case OrderStatusFilter.confirmed:
        return 'CONFIRMED';
      case OrderStatusFilter.shipping:
        return 'SHIPPING';
      case OrderStatusFilter.completed:
        return 'COMPLETED';
      case OrderStatusFilter.cancelled:
        return 'CANCELLED';
    }
  }

  String get displayName {
    switch (this) {
      case OrderStatusFilter.all:
        return 'Tất cả';
      case OrderStatusFilter.created:
        return 'Chờ xác nhận';
      case OrderStatusFilter.confirmed:
        return 'Đã xác nhận';
      case OrderStatusFilter.shipping:
        return 'Đang giao';
      case OrderStatusFilter.completed:
        return 'Hoàn thành';
      case OrderStatusFilter.cancelled:
        return 'Đã hủy';
    }
  }
}

// ==================== STATE ====================

class OrderState extends Equatable {
  // === Form tạo đơn ===
  final ListingItem? item;
  final String name;
  final String phone;
  final String address; // Tỉnh/Huyện/Xã (display)
  final String addressDetail; // Số nhà, đường
  final String note;
  final int quantity;
  final int paymentMethod;
  final int? toProvinceId;
  final int? toDistrictId;
  final String? toWardCode;
  final double shippingFee;
  final OrderFormStatus status;
  final String? errorMessage;
  final OrderResponse? createdOrder;

  // === Chi tiết đơn ===
  final OrderDetailStatus detailStatus;
  final OrderResponse? orderDetail;

  // === Danh sách đơn ===
  final OrderListStatus listStatus;
  final List<OrderResponse> orders;
  final int currentPage;
  final bool hasMore;
  final OrderFilterType filterType;
  final OrderStatusFilter statusFilter;
  final int? userId;

  // === Xác nhận đơn (seller) ===
  final OrderConfirmStatus confirmStatus;
  final int? confirmingOrderId;

  const OrderState({
    // Form
    this.item,
    this.name = '',
    this.phone = '',
    this.address = '',
    this.addressDetail = '',
    this.note = '',
    this.quantity = 1,
    this.paymentMethod = 0,
    this.toProvinceId,
    this.toDistrictId,
    this.toWardCode,
    this.shippingFee = 0,
    this.status = OrderFormStatus.initial,
    this.errorMessage,
    this.createdOrder,
    // Detail
    this.detailStatus = OrderDetailStatus.initial,
    this.orderDetail,
    // List
    this.listStatus = OrderListStatus.initial,
    this.orders = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.filterType = OrderFilterType.buying,
    this.statusFilter = OrderStatusFilter.all,
    this.userId,
    // Confirm
    this.confirmStatus = OrderConfirmStatus.initial,
    this.confirmingOrderId,
  });

  // === Computed properties ===
  double get unitPrice => double.tryParse(item?.price ?? '0') ?? 0;
  double get subtotalPrice => unitPrice * quantity;
  double get totalPrice => subtotalPrice + shippingFee;
  bool get isValid => name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty;

  /// Địa chỉ đầy đủ để gửi lên API: "Số nhà, đường, Phường, Quận, Tỉnh"
  String get fullCustomerAddress {
    if (addressDetail.isNotEmpty && address.isNotEmpty) {
      return '$addressDetail, $address';
    }
    return addressDetail.isNotEmpty ? addressDetail : address;
  }

  OrderState copyWith({
    // Form
    ListingItem? item,
    String? name,
    String? phone,
    String? address,
    String? addressDetail,
    String? note,
    int? quantity,
    int? paymentMethod,
    int? toProvinceId,
    int? toDistrictId,
    String? toWardCode,
    double? shippingFee,
    OrderFormStatus? status,
    String? errorMessage,
    OrderResponse? createdOrder,
    // Detail
    OrderDetailStatus? detailStatus,
    OrderResponse? orderDetail,
    // List
    OrderListStatus? listStatus,
    List<OrderResponse>? orders,
    int? currentPage,
    bool? hasMore,
    OrderFilterType? filterType,
    OrderStatusFilter? statusFilter,
    int? userId,
    // Confirm
    OrderConfirmStatus? confirmStatus,
    int? confirmingOrderId,
  }) {
    return OrderState(
      // Form
      item: item ?? this.item,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      addressDetail: addressDetail ?? this.addressDetail,
      note: note ?? this.note,
      quantity: quantity ?? this.quantity,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      toProvinceId: toProvinceId ?? this.toProvinceId,
      toDistrictId: toDistrictId ?? this.toDistrictId,
      toWardCode: toWardCode ?? this.toWardCode,
      shippingFee: shippingFee ?? this.shippingFee,
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdOrder: createdOrder ?? this.createdOrder,
      // Detail
      detailStatus: detailStatus ?? this.detailStatus,
      orderDetail: orderDetail ?? this.orderDetail,
      // List
      listStatus: listStatus ?? this.listStatus,
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      filterType: filterType ?? this.filterType,
      statusFilter: statusFilter ?? this.statusFilter,
      userId: userId ?? this.userId,
      // Confirm
      confirmStatus: confirmStatus ?? this.confirmStatus,
      confirmingOrderId: confirmingOrderId ?? this.confirmingOrderId,
    );
  }

  @override
  List<Object?> get props => [
    // Form
    item, name, phone, address, addressDetail, note, quantity, paymentMethod,
    toProvinceId, toDistrictId, toWardCode, shippingFee,
    status, errorMessage, createdOrder,
    // Detail
    detailStatus, orderDetail,
    // List
    listStatus, orders, currentPage, hasMore,
    filterType, statusFilter, userId,
    // Confirm
    confirmStatus, confirmingOrderId,
  ];
}