// // enum OrderStatus { pending, confirmed, picking, delivering, delivered, cancelled }
// //
// // extension OrderStatusExtension on OrderStatus {
// //   String get label {
// //     switch (this) {
// //       case OrderStatus.pending:
// //         return 'Chờ xác nhận';
// //       case OrderStatus.confirmed:
// //         return 'Đã xác nhận';
// //       case OrderStatus.picking:
// //         return 'Đang lấy hàng';
// //       case OrderStatus.delivering:
// //         return 'Đang giao';
// //       case OrderStatus.delivered:
// //         return 'Đã giao';
// //       case OrderStatus.cancelled:
// //         return 'Đã hủy';
// //     }
// //   }
// //
// //   bool get isCompleted {
// //     return this == OrderStatus.delivered || this == OrderStatus.cancelled;
// //   }
// // }
// //
// // class ShipperOrderModel {
// //   final String id;
// //   final String orderCode;
// //   final String customerName;
// //   final String customerPhone;
// //   final String customerAddress;
// //   final String sellerName;
// //   final String sellerPhone;
// //   final String sellerAddress;
// //   final List<OrderItemModel> items;
// //   final double totalAmount;
// //   final double shippingFee;
// //   final OrderStatus status;
// //   final DateTime createdAt;
// //   final DateTime? deliveredAt;
// //   final String? note;
// //
// //   ShipperOrderModel({
// //     required this.id,
// //     required this.orderCode,
// //     required this.customerName,
// //     required this.customerPhone,
// //     required this.customerAddress,
// //     required this.sellerName,
// //     required this.sellerPhone,
// //     required this.sellerAddress,
// //     required this.items,
// //     required this.totalAmount,
// //     required this.shippingFee,
// //     required this.status,
// //     required this.createdAt,
// //     this.deliveredAt,
// //     this.note,
// //   });
// //
// //   ShipperOrderModel copyWith({
// //     String? id,
// //     String? orderCode,
// //     String? customerName,
// //     String? customerPhone,
// //     String? customerAddress,
// //     String? sellerName,
// //     String? sellerPhone,
// //     String? sellerAddress,
// //     List<OrderItemModel>? items,
// //     double? totalAmount,
// //     double? shippingFee,
// //     OrderStatus? status,
// //     DateTime? createdAt,
// //     DateTime? deliveredAt,
// //     String? note,
// //   }) {
// //     return ShipperOrderModel(
// //       id: id ?? this.id,
// //       orderCode: orderCode ?? this.orderCode,
// //       customerName: customerName ?? this.customerName,
// //       customerPhone: customerPhone ?? this.customerPhone,
// //       customerAddress: customerAddress ?? this.customerAddress,
// //       sellerName: sellerName ?? this.sellerName,
// //       sellerPhone: sellerPhone ?? this.sellerPhone,
// //       sellerAddress: sellerAddress ?? this.sellerAddress,
// //       items: items ?? this.items,
// //       totalAmount: totalAmount ?? this.totalAmount,
// //       shippingFee: shippingFee ?? this.shippingFee,
// //       status: status ?? this.status,
// //       createdAt: createdAt ?? this.createdAt,
// //       deliveredAt: deliveredAt ?? this.deliveredAt,
// //       note: note ?? this.note,
// //     );
// //   }
// // }
// //
// // class OrderItemModel {
// //   final String id;
// //   final String name;
// //   final String imageUrl;
// //   final int quantity;
// //   final double price;
// //
// //   OrderItemModel({
// //     required this.id,
// //     required this.name,
// //     required this.imageUrl,
// //     required this.quantity,
// //     required this.price,
// //   });
// // }
//
//
// enum OrderStatus { pending, confirmed, picking, delivering, delivered, cancelled }
//
// extension OrderStatusExtension on OrderStatus {
//   String get label {
//     switch (this) {
//       case OrderStatus.pending:
//         return 'Chờ xác nhận';
//       case OrderStatus.confirmed:
//         return 'Đã xác nhận';
//       case OrderStatus.picking:
//         return 'Đang lấy hàng';
//       case OrderStatus.delivering:
//         return 'Đang giao';
//       case OrderStatus.delivered:
//         return 'Đã giao';
//       case OrderStatus.cancelled:
//         return 'Đã hủy';
//     }
//   }
//
//   bool get isCompleted {
//     return this == OrderStatus.delivered || this == OrderStatus.cancelled;
//   }
// }
//
// class ShipperOrderModel {
//   final String id;
//   final String orderCode;
//   final String customerName;
//   final String customerPhone;
//   final String customerAddress;
//   final String sellerName;
//   final String sellerPhone;
//   final String sellerAddress;
//   final List<OrderItemModel> items;
//   final double totalAmount;
//   final double shippingFee;
//   final OrderStatus status;
//   final DateTime createdAt;
//   final DateTime? deliveredAt;
//   final String? note;
//
//   ShipperOrderModel({
//     required this.id,
//     required this.orderCode,
//     required this.customerName,
//     required this.customerPhone,
//     required this.customerAddress,
//     required this.sellerName,
//     required this.sellerPhone,
//     required this.sellerAddress,
//     required this.items,
//     required this.totalAmount,
//     required this.shippingFee,
//     required this.status,
//     required this.createdAt,
//     this.deliveredAt,
//     this.note,
//   });
//
//   ShipperOrderModel copyWith({
//     String? id,
//     String? orderCode,
//     String? customerName,
//     String? customerPhone,
//     String? customerAddress,
//     String? sellerName,
//     String? sellerPhone,
//     String? sellerAddress,
//     List<OrderItemModel>? items,
//     double? totalAmount,
//     double? shippingFee,
//     OrderStatus? status,
//     DateTime? createdAt,
//     DateTime? deliveredAt,
//     String? note,
//   }) {
//     return ShipperOrderModel(
//       id: id ?? this.id,
//       orderCode: orderCode ?? this.orderCode,
//       customerName: customerName ?? this.customerName,
//       customerPhone: customerPhone ?? this.customerPhone,
//       customerAddress: customerAddress ?? this.customerAddress,
//       sellerName: sellerName ?? this.sellerName,
//       sellerPhone: sellerPhone ?? this.sellerPhone,
//       sellerAddress: sellerAddress ?? this.sellerAddress,
//       items: items ?? this.items,
//       totalAmount: totalAmount ?? this.totalAmount,
//       shippingFee: shippingFee ?? this.shippingFee,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       deliveredAt: deliveredAt ?? this.deliveredAt,
//       note: note ?? this.note,
//     );
//   }
// }
//
// class OrderItemModel {
//   final String id;
//   final String name;
//   final String imageUrl;
//   final int quantity;
//   final double price;
//
//   OrderItemModel({
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.quantity,
//     required this.price,
//   });
// }


enum OrderStatus {
  pending,
  confirmed,
  picking,
  delivering,
  delivered,
  cancelled;

  bool get isCompleted => this == OrderStatus.delivered || this == OrderStatus.cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
        return 'Đã xác nhận';
      case OrderStatus.picking:
        return 'Đang lấy hàng';
      case OrderStatus.delivering:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Đã giao hàng';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }
}

class ShipperOrderModel {
  final String id;
  final String orderCode;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String sellerName;
  final String sellerPhone;
  final String sellerAddress;
  final List<OrderItemModel> items;
  final double totalAmount;
  final double shippingFee;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? note;

  ShipperOrderModel({
    required this.id,
    required this.orderCode,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.sellerName,
    required this.sellerPhone,
    required this.sellerAddress,
    required this.items,
    required this.totalAmount,
    required this.shippingFee,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    this.note,
  });

  ShipperOrderModel copyWith({
    String? id,
    String? orderCode,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? sellerName,
    String? sellerPhone,
    String? sellerAddress,
    List<OrderItemModel>? items,
    double? totalAmount,
    double? shippingFee,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? deliveredAt,
    String? note,
  }) {
    return ShipperOrderModel(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      sellerName: sellerName ?? this.sellerName,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingFee: shippingFee ?? this.shippingFee,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      note: note ?? this.note,
    );
  }

  double get grandTotal => totalAmount + shippingFee;
}

class OrderItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  double get totalPrice => price * quantity;
}