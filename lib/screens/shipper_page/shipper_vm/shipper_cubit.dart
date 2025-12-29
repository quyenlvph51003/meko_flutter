import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/local/shipper_model.dart';
import 'package:meko_project/screens/shipper_page/shipper_vm/shipper_state.dart';

class ShipperCubit extends Cubit<ShipperState> {
  ShipperCubit() : super(ShipperState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: ShipperStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(
        status: ShipperStatus.loaded,
        activeOrders: getMockActiveOrders(),
        historyOrders: getMockHistoryOrders(),
      ));
    } catch (e) {
      emit(state.copyWith(status: ShipperStatus.error, errorMessage: 'Không thể tải đơn hàng'));
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final updatedActiveOrders = state.activeOrders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          status: newStatus,
          deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
        );
      }
      return order;
    }).toList();

    List<ShipperOrderModel> finalActiveOrders = [];
    List<ShipperOrderModel> finalHistoryOrders = List.from(state.historyOrders);

    for (var order in updatedActiveOrders) {
      if (order.status.isCompleted) {
        finalHistoryOrders.insert(0, order);
      } else {
        finalActiveOrders.add(order);
      }
    }

    emit(state.copyWith(activeOrders: finalActiveOrders, historyOrders: finalHistoryOrders));
  }

  Future<void> confirmPickup(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.picking);
  }

  Future<void> startDelivery(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.delivering);
  }

  Future<void> completeDelivery(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.delivered);
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  List<ShipperOrderModel> getMockActiveOrders() {
    return [
      ShipperOrderModel(
        id: '1',
        orderCode: 'MK240001',
        customerName: 'Nguyễn Văn An',
        customerPhone: '0901234567',
        customerAddress: '123 Nguyễn Huệ, Q.1, TP.HCM',
        sellerName: 'Shop Đồ Cũ ABC',
        sellerPhone: '0912345678',
        sellerAddress: '456 Lê Lợi, Q.3, TP.HCM',
        items: [
          OrderItemModel(id: '1', name: 'Áo khoác jean vintage', imageUrl: 'https://picsum.photos/200', quantity: 1, price: 250000),
          OrderItemModel(id: '2', name: 'Quần baggy đen', imageUrl: 'https://picsum.photos/201', quantity: 1, price: 180000),
        ],
        totalAmount: 430000,
        shippingFee: 25000,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        note: 'Giao giờ hành chính',
      ),
      ShipperOrderModel(
        id: '2',
        orderCode: 'MK240002',
        customerName: 'Trần Thị Bình',
        customerPhone: '0909876543',
        customerAddress: '789 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM',
        sellerName: 'Secondhand Store',
        sellerPhone: '0923456789',
        sellerAddress: '321 Cách Mạng Tháng 8, Q.10, TP.HCM',
        items: [
          OrderItemModel(id: '3', name: 'Túi xách da', imageUrl: 'https://picsum.photos/202', quantity: 1, price: 350000),
        ],
        totalAmount: 350000,
        shippingFee: 30000,
        status: OrderStatus.picking,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ShipperOrderModel(
        id: '3',
        orderCode: 'MK240003',
        customerName: 'Lê Minh Cường',
        customerPhone: '0918765432',
        customerAddress: '555 Võ Văn Tần, Q.3, TP.HCM',
        sellerName: 'Vintage Corner',
        sellerPhone: '0934567890',
        sellerAddress: '999 Nguyễn Thị Minh Khai, Q.1, TP.HCM',
        items: [
          OrderItemModel(id: '4', name: 'Đồng hồ cổ điển', imageUrl: 'https://picsum.photos/203', quantity: 1, price: 500000),
        ],
        totalAmount: 500000,
        shippingFee: 20000,
        status: OrderStatus.delivering,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  List<ShipperOrderModel> getMockHistoryOrders() {
    return [
      ShipperOrderModel(
        id: '4',
        orderCode: 'MK230099',
        customerName: 'Phạm Thị Dung',
        customerPhone: '0927654321',
        customerAddress: '111 Hai Bà Trưng, Q.1, TP.HCM',
        sellerName: 'Thrift Shop VN',
        sellerPhone: '0945678901',
        sellerAddress: '222 Pasteur, Q.3, TP.HCM',
        items: [
          OrderItemModel(id: '5', name: 'Váy hoa vintage', imageUrl: 'https://picsum.photos/204', quantity: 1, price: 280000),
        ],
        totalAmount: 280000,
        shippingFee: 25000,
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        deliveredAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      ShipperOrderModel(
        id: '5',
        orderCode: 'MK230098',
        customerName: 'Hoàng Văn Em',
        customerPhone: '0936543210',
        customerAddress: '333 Trần Hưng Đạo, Q.5, TP.HCM',
        sellerName: 'Used Items Store',
        sellerPhone: '0956789012',
        sellerAddress: '444 Nguyễn Trãi, Q.5, TP.HCM',
        items: [
          OrderItemModel(id: '6', name: 'Giày sneaker', imageUrl: 'https://picsum.photos/205', quantity: 1, price: 450000),
        ],
        totalAmount: 450000,
        shippingFee: 30000,
        status: OrderStatus.cancelled,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Khách hủy đơn',
      ),
    ];
  }
}

// class ShipperCubit extends Cubit<ShipperState> {
//   ShipperCubit() : super(ShipperState());
//
//   Future<void> loadOrders() async {
//     emit(state.copyWith(status: ShipperStatus.loading));
//     try {
//       await Future.delayed(const Duration(milliseconds: 500));
//       emit(state.copyWith(
//         status: ShipperStatus.loaded,
//         activeOrders: getMockActiveOrders(),
//         historyOrders: getMockHistoryOrders(),
//       ));
//     } catch (e) {
//       emit(state.copyWith(status: ShipperStatus.error, errorMessage: 'Không thể tải đơn hàng'));
//     }
//   }
//
//   void changeTab(int index) {
//     emit(state.copyWith(selectedTabIndex: index));
//   }
//
//   Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
//     final updatedActiveOrders = state.activeOrders.map((order) {
//       if (order.id == orderId) {
//         return order.copyWith(
//           status: newStatus,
//           deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
//         );
//       }
//       return order;
//     }).toList();
//
//     List<ShipperOrderModel> finalActiveOrders = [];
//     List<ShipperOrderModel> finalHistoryOrders = List.from(state.historyOrders);
//
//     for (var order in updatedActiveOrders) {
//       if (order.status.isCompleted) {
//         finalHistoryOrders.insert(0, order);
//       } else {
//         finalActiveOrders.add(order);
//       }
//     }
//
//     emit(state.copyWith(activeOrders: finalActiveOrders, historyOrders: finalHistoryOrders));
//   }
//
//   Future<void> confirmPickup(String orderId) async {
//     await updateOrderStatus(orderId, OrderStatus.picking);
//   }
//
//   Future<void> startDelivery(String orderId) async {
//     await updateOrderStatus(orderId, OrderStatus.delivering);
//   }
//
//   Future<void> completeDelivery(String orderId) async {
//     await updateOrderStatus(orderId, OrderStatus.delivered);
//   }
//
//   Future<void> cancelOrder(String orderId) async {
//     await updateOrderStatus(orderId, OrderStatus.cancelled);
//   }
//
//   List<ShipperOrderModel> getMockActiveOrders() {
//     return [
//       ShipperOrderModel(
//         id: '1',
//         orderCode: 'MK240001',
//         customerName: 'Nguyễn Văn An',
//         customerPhone: '0901234567',
//         customerAddress: '123 Nguyễn Huệ, Q.1, TP.HCM',
//         sellerName: 'Shop Đồ Cũ ABC',
//         sellerPhone: '0912345678',
//         sellerAddress: '456 Lê Lợi, Q.3, TP.HCM',
//         items: [
//           OrderItemModel(id: '1', name: 'Áo khoác jean vintage', imageUrl: 'https://picsum.photos/200', quantity: 1, price: 250000),
//           OrderItemModel(id: '2', name: 'Quần baggy đen', imageUrl: 'https://picsum.photos/201', quantity: 1, price: 180000),
//         ],
//         totalAmount: 430000,
//         shippingFee: 25000,
//         status: OrderStatus.confirmed,
//         createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//         note: 'Giao giờ hành chính',
//       ),
//       ShipperOrderModel(
//         id: '2',
//         orderCode: 'MK240002',
//         customerName: 'Trần Thị Bình',
//         customerPhone: '0909876543',
//         customerAddress: '789 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM',
//         sellerName: 'Secondhand Store',
//         sellerPhone: '0923456789',
//         sellerAddress: '321 Cách Mạng Tháng 8, Q.10, TP.HCM',
//         items: [
//           OrderItemModel(id: '3', name: 'Túi xách da', imageUrl: 'https://picsum.photos/202', quantity: 1, price: 350000),
//         ],
//         totalAmount: 350000,
//         shippingFee: 30000,
//         status: OrderStatus.picking,
//         createdAt: DateTime.now().subtract(const Duration(hours: 1)),
//       ),
//       ShipperOrderModel(
//         id: '3',
//         orderCode: 'MK240003',
//         customerName: 'Lê Minh Cường',
//         customerPhone: '0918765432',
//         customerAddress: '555 Võ Văn Tần, Q.3, TP.HCM',
//         sellerName: 'Vintage Corner',
//         sellerPhone: '0934567890',
//         sellerAddress: '999 Nguyễn Thị Minh Khai, Q.1, TP.HCM',
//         items: [
//           OrderItemModel(id: '4', name: 'Đồng hồ cổ điển', imageUrl: 'https://picsum.photos/203', quantity: 1, price: 500000),
//         ],
//         totalAmount: 500000,
//         shippingFee: 20000,
//         status: OrderStatus.delivering,
//         createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
//       ),
//     ];
//   }
//
//   List<ShipperOrderModel> getMockHistoryOrders() {
//     return [
//       ShipperOrderModel(
//         id: '4',
//         orderCode: 'MK230099',
//         customerName: 'Phạm Thị Dung',
//         customerPhone: '0927654321',
//         customerAddress: '111 Hai Bà Trưng, Q.1, TP.HCM',
//         sellerName: 'Thrift Shop VN',
//         sellerPhone: '0945678901',
//         sellerAddress: '222 Pasteur, Q.3, TP.HCM',
//         items: [
//           OrderItemModel(id: '5', name: 'Váy hoa vintage', imageUrl: 'https://picsum.photos/204', quantity: 1, price: 280000),
//         ],
//         totalAmount: 280000,
//         shippingFee: 25000,
//         status: OrderStatus.delivered,
//         createdAt: DateTime.now().subtract(const Duration(days: 1)),
//         deliveredAt: DateTime.now().subtract(const Duration(hours: 20)),
//       ),
//       ShipperOrderModel(
//         id: '5',
//         orderCode: 'MK230098',
//         customerName: 'Hoàng Văn Em',
//         customerPhone: '0936543210',
//         customerAddress: '333 Trần Hưng Đạo, Q.5, TP.HCM',
//         sellerName: 'Used Items Store',
//         sellerPhone: '0956789012',
//         sellerAddress: '444 Nguyễn Trãi, Q.5, TP.HCM',
//         items: [
//           OrderItemModel(id: '6', name: 'Giày sneaker', imageUrl: 'https://picsum.photos/205', quantity: 1, price: 450000),
//         ],
//         totalAmount: 450000,
//         shippingFee: 30000,
//         status: OrderStatus.cancelled,
//         createdAt: DateTime.now().subtract(const Duration(days: 2)),
//         note: 'Khách hủy đơn',
//       ),
//     ];
//   }
// }