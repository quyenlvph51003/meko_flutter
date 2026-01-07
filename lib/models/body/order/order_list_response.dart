import 'package:meko_project/models/body/order/order_response.dart';

class OrderListResponse {
  final List<OrderResponse> orders;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasMore;

  OrderListResponse({
    required this.orders,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasMore,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    // API có thể trả về data là Map hoặc List
    List<dynamic> ordersJson = [];

    final dynamic data = json['data'];
    if (data is List) {
      // data là List các order trực tiếp
      ordersJson = data;
    } else if (data is Map<String, dynamic>) {
      // data là Map chứa content
      ordersJson = data['content'] ?? [];
    } else {
      // Fallback: lấy từ content ở root level
      ordersJson = json['content'] ?? [];
    }

    return OrderListResponse(
      orders: ordersJson.map((e) => OrderResponse.fromJson(e as Map<String, dynamic>)).toList(),
      totalItems: json['total_items'] ?? json['totalItems'] ?? ordersJson.length,
      totalPages: json['total_pages'] ?? json['totalPages'] ?? 1,
      currentPage: json['current_page'] ?? json['page'] ?? 0,
      hasMore: json['has_more'] ?? (json['current_page'] ?? 0) < (json['total_pages'] ?? 1) - 1,
    );
  }

  factory OrderListResponse.empty() {
    return OrderListResponse(
      orders: [],
      totalItems: 0,
      totalPages: 0,
      currentPage: 0,
      hasMore: false,
    );
  }
}

/// Enum cho các loại filter đơn hàng
enum OrderFilterType {
  all,           // Tất cả
  selling,       // Đơn đang bán (seller_id)
  buying,        // Đơn đã mua (customer_id)
}

/// Enum cho trạng thái đơn hàng
enum OrderStatusFilter {
  all,           // Tất cả
  created,       // Mới tạo
  confirmed,     // Đã xác nhận
  shipping,      // Đang giao
  completed,     // Hoàn thành
  cancelled,     // Đã hủy
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