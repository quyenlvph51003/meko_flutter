// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:meko_project/consts/app_colcor.dart';
// import 'package:meko_project/models/local/shipper_model.dart';
//
// class OrderStatusBadge extends StatelessWidget {
//   final OrderStatus status;
//
//   const OrderStatusBadge({super.key, required this.status});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: getStatusColor().withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: getStatusColor().withOpacity(0.5)),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(width: 6, height: 6, decoration: BoxDecoration(color: getStatusColor(), shape: BoxShape.circle)),
//           const SizedBox(width: 6),
//           Text(status.label, style: TextStyle(color: getStatusColor(), fontSize: 12, fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
//
//   Color getStatusColor() {
//     switch (status) {
//       case OrderStatus.pending:
//         return Colors.orange;
//       case OrderStatus.confirmed:
//         return Colors.blue;
//       case OrderStatus.picking:
//         return Colors.purple;
//       case OrderStatus.delivering:
//         return AppColor.cMain;
//       case OrderStatus.delivered:
//         return Colors.green;
//       case OrderStatus.cancelled:
//         return Colors.red;
//     }
//   }
// }
//
// class ShipperTabBar extends StatelessWidget {
//   final int selectedIndex;
//   final int activeCount;
//   final int historyCount;
//   final Function(int) onTabChanged;
//
//   const ShipperTabBar({
//     super.key,
//     required this.selectedIndex,
//     required this.activeCount,
//     required this.historyCount,
//     required this.onTabChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
//       child: Row(
//         children: [
//           Expanded(child: buildTabItem('Đang xử lý', activeCount, selectedIndex == 0, () { return onTabChanged(0); })),
//           Expanded(child: buildTabItem('Lịch sử', historyCount, selectedIndex == 1, () { return onTabChanged(1); })),
//         ],
//       ),
//     );
//   }
//
//   Widget buildTabItem(String title, int count, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(color: isSelected ? AppColor.cMain : Colors.transparent, borderRadius: BorderRadius.circular(10)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.w600, fontSize: 14)),
//             const SizedBox(width: 6),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(color: isSelected ? Colors.white.withOpacity(0.2) : Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
//               child: Text(count.toString(), style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 12)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ShipperOrderCard extends StatelessWidget {
//   final ShipperOrderModel order;
//   final VoidCallback onTap;
//
//   const ShipperOrderCard({super.key, required this.order, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final formatter = NumberFormat('#,###', 'vi_VN');
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
//         ),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(color: AppColor.cMain.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//                     child: Icon(Icons.receipt_long_rounded, color: AppColor.cMain, size: 20),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(order.orderCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//                         const SizedBox(height: 2),
//                         Text(DateFormat('HH:mm - dd/MM/yyyy').format(order.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
//                       ],
//                     ),
//                   ),
//                   OrderStatusBadge(status: order.status),
//                 ],
//               ),
//             ),
//             const Divider(height: 1),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   buildAddressRow(Icons.store_rounded, Colors.orange, 'Lấy hàng', order.sellerName, order.sellerAddress),
//                   const SizedBox(height: 12),
//                   buildAddressRow(Icons.location_on_rounded, AppColor.cMain, 'Giao đến', order.customerName, order.customerAddress),
//                 ],
//               ),
//             ),
//             const Divider(height: 1),
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   Text('${order.items.length} sản phẩm', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                   const Spacer(),
//                   Text('Thu hộ: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                   Text('${formatter.format(order.totalAmount + order.shippingFee)}đ', style: TextStyle(color: AppColor.cMain, fontWeight: FontWeight.bold, fontSize: 15)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildAddressRow(IconData icon, Color iconColor, String title, String name, String address) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 16)),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(children: [
//                 Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
//                 const SizedBox(width: 8),
//                 Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
//               ]),
//               const SizedBox(height: 2),
//               Text(address, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class EmptyOrderState extends StatelessWidget {
//   final bool isHistory;
//
//   const EmptyOrderState({super.key, required this.isHistory});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(isHistory ? Icons.history_rounded : Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
//             const SizedBox(height: 16),
//             Text(isHistory ? 'Chưa có lịch sử đơn hàng' : 'Không có đơn hàng nào', style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
//             const SizedBox(height: 8),
//             Text(isHistory ? 'Các đơn hàng đã hoàn thành sẽ hiển thị ở đây' : 'Đơn hàng mới sẽ hiển thị ở đây', style: TextStyle(fontSize: 13, color: Colors.grey.shade400), textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class OrderActionButtons extends StatelessWidget {
//   final OrderStatus status;
//   final VoidCallback? onPickup;
//   final VoidCallback? onStartDelivery;
//   final VoidCallback? onComplete;
//   final VoidCallback? onCancel;
//   final VoidCallback? onCall;
//
//   const OrderActionButtons({super.key, required this.status, this.onPickup, this.onStartDelivery, this.onComplete, this.onCancel, this.onCall});
//
//   @override
//   Widget build(BuildContext context) {
//     if (status.isCompleted) return const SizedBox.shrink();
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
//       child: SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: onCall,
//                     icon: const Icon(Icons.phone_rounded, size: 18),
//                     label: const Text('Gọi điện', style: TextStyle(fontWeight: FontWeight.w600)),
//                     style: OutlinedButton.styleFrom(foregroundColor: AppColor.cMain, padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: AppColor.cMain), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(flex: 2, child: buildPrimaryButton()),
//               ],
//             ),
//             if (status != OrderStatus.delivered) ...[
//               const SizedBox(height: 8),
//               TextButton(onPressed: onCancel, child: Text('Hủy đơn hàng', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w500))),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildPrimaryButton() {
//     String label;
//     IconData icon;
//     VoidCallback? onTap;
//
//     switch (status) {
//       case OrderStatus.confirmed:
//         label = 'Đã lấy hàng';
//         icon = Icons.inventory_2_rounded;
//         onTap = onPickup;
//         break;
//       case OrderStatus.picking:
//         label = 'Bắt đầu giao';
//         icon = Icons.local_shipping_rounded;
//         onTap = onStartDelivery;
//         break;
//       case OrderStatus.delivering:
//         label = 'Hoàn thành';
//         icon = Icons.check_circle_rounded;
//         onTap = onComplete;
//         break;
//       default:
//         label = 'Xử lý';
//         icon = Icons.check;
//         onTap = null;
//     }
//
//     return ElevatedButton.icon(
//       onPressed: onTap,
//       icon: Icon(icon, size: 20),
//       label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//       style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
//     );
//   }
// }
//
// class OrderAddressCard extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final Color iconColor;
//   final String name;
//   final String phone;
//   final String address;
//   final VoidCallback? onCallTap;
//   final VoidCallback? onMapTap;
//
//   const OrderAddressCard({super.key, required this.title, required this.icon, required this.iconColor, required this.name, required this.phone, required this.address, this.onCallTap, this.onMapTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 18)),
//             const SizedBox(width: 10),
//             Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
//           ]),
//           const SizedBox(height: 12),
//           Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//           const SizedBox(height: 4),
//           Row(children: [Icon(Icons.phone_rounded, size: 14, color: Colors.grey.shade400), const SizedBox(width: 6), Text(phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 13))]),
//           const SizedBox(height: 4),
//           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade400), const SizedBox(width: 6), Expanded(child: Text(address, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))]),
//           const SizedBox(height: 12),
//           Row(children: [
//             Expanded(
//               child: OutlinedButton.icon(
//                 onPressed: onCallTap,
//                 icon: const Icon(Icons.phone_rounded, size: 16),
//                 label: const Text('Gọi điện'),
//                 style: OutlinedButton.styleFrom(foregroundColor: AppColor.cMain, side: BorderSide(color: AppColor.cMain.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: OutlinedButton.icon(
//                 onPressed: onMapTap,
//                 icon: const Icon(Icons.map_rounded, size: 16),
//                 label: const Text('Bản đồ'),
//                 style: OutlinedButton.styleFrom(foregroundColor: AppColor.cMain, side: BorderSide(color: AppColor.cMain.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//               ),
//             ),
//           ]),
//         ],
//       ),
//     );
//   }
// }
//
// class OrderItemsCard extends StatelessWidget {
//   final List<OrderItemModel> items;
//
//   const OrderItemsCard({super.key, required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     final formatter = NumberFormat('#,###', 'vi_VN');
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColor.cMain.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.shopping_bag_rounded, color: AppColor.cMain, size: 18)),
//             const SizedBox(width: 10),
//             Text('Sản phẩm (${items.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//           ]),
//           const SizedBox(height: 12),
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: items.length,
//             separatorBuilder: (context, index) { return const Divider(height: 16); },
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return Row(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(item.imageUrl, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
//                       return Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.image_rounded, color: Colors.grey.shade400));
//                     }),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
//                         const SizedBox(height: 4),
//                         Text('x${item.quantity}', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
//                       ],
//                     ),
//                   ),
//                   Text('${formatter.format(item.price)}đ', style: TextStyle(color: AppColor.cMain, fontWeight: FontWeight.bold, fontSize: 14)),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class OrderPaymentSummary extends StatelessWidget {
//   final double totalAmount;
//   final double shippingFee;
//   final String? note;
//
//   const OrderPaymentSummary({super.key, required this.totalAmount, required this.shippingFee, this.note});
//
//   @override
//   Widget build(BuildContext context) {
//     final formatter = NumberFormat('#,###', 'vi_VN');
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.payments_rounded, color: Colors.green, size: 18)),
//             const SizedBox(width: 10),
//             const Text('Thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//           ]),
//           const SizedBox(height: 16),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Tiền hàng', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)), Text('${formatter.format(totalAmount)}đ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
//           const SizedBox(height: 8),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Phí vận chuyển', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)), Text('${formatter.format(shippingFee)}đ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
//           const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tổng thu hộ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('${formatter.format(totalAmount + shippingFee)}đ', style: TextStyle(color: AppColor.cMain, fontWeight: FontWeight.bold, fontSize: 18))]),
//           if (note != null && note!.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.withOpacity(0.3))),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.note_rounded, color: Colors.amber.shade700, size: 18),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Ghi chú', style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.w600, fontSize: 12)),
//                         const SizedBox(height: 2),
//                         Text(note!, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// class OrderDetailHeader extends StatelessWidget {
//   final ShipperOrderModel order;
//
//   const OrderDetailHeader({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColor.cMain.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.receipt_long_rounded, color: AppColor.cMain, size: 28)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(order.orderCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                     const SizedBox(height: 4),
//                     Text(DateFormat('HH:mm - dd/MM/yyyy').format(order.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
//                   ],
//                 ),
//               ),
//               OrderStatusBadge(status: order.status),
//             ],
//           ),
//           if (order.deliveredAt != null) ...[
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//               child: Row(children: [
//                 const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
//                 const SizedBox(width: 8),
//                 Text('Giao lúc: ${DateFormat('HH:mm - dd/MM/yyyy').format(order.deliveredAt!)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13)),
//               ]),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/models/local/shipper_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: getStatusColor().withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: getStatusColor(), shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(status.label, style: TextStyle(color: getStatusColor(), fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color getStatusColor() {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.picking:
        return Colors.purple;
      case OrderStatus.delivering:
        return AppColor.cMain;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

class ShipperTabBar extends StatelessWidget {
  final TabController tabController;
  final int activeCount;
  final int historyCount;
  final Function(int) onTabChanged;

  const ShipperTabBar({
    super.key,
    required this.tabController,
    required this.activeCount,
    required this.historyCount,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return ListenableBuilder(
            listenable: tabController.animation!,
            builder: (context, child) {
              final progress = tabController.animation!.value;
              return Stack(
                children: [
                  Positioned(
                    left: progress * tabWidth,
                    top: 0,
                    bottom: 0,
                    width: tabWidth,
                    child: Container(
                      decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: buildTabItem('Đang xử lý', activeCount, 1 - progress, 0)),
                      Expanded(child: buildTabItem('Lịch sử', historyCount, progress, 1)),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildTabItem(String title, int count, double animValue, int index) {
    return GestureDetector(
      onTap: () { onTabChanged(index); },
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(color: Color.lerp(Colors.grey.shade600, Colors.white, animValue), fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Color.lerp(Colors.grey.shade300, Colors.white.withOpacity(0.2), animValue), borderRadius: BorderRadius.circular(10)),
              child: Text(count.toString(), style: TextStyle(color: Color.lerp(Colors.grey.shade600, Colors.white, animValue), fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShipperOrderCard extends StatelessWidget {
  final ShipperOrderModel order;
  final VoidCallback onTap;

  const ShipperOrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColor.cMain.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.receipt_long_rounded, color: AppColor.cMain, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.orderCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(DateFormat('HH:mm - dd/MM/yyyy').format(order.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  buildAddressRow(Icons.store_rounded, Colors.orange, 'Lấy hàng', order.sellerName, order.sellerAddress),
                  const SizedBox(height: 12),
                  buildAddressRow(Icons.location_on_rounded, AppColor.cMain, 'Giao đến', order.customerName, order.customerAddress),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text('${order.items.length} sản phẩm', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const Spacer(),
                  Text('Thu hộ: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  Text('${formatter.format(order.totalAmount + order.shippingFee)}đ', style: TextStyle(color: AppColor.cMain, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddressRow(IconData icon, Color iconColor, String title, String name, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: iconColor, size: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                const SizedBox(width: 8),
                Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 2),
              Text(address, style: TextStyle(color: Colors.grey.shade600, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

class EmptyOrderState extends StatelessWidget {
  final bool isHistory;

  const EmptyOrderState({super.key, required this.isHistory});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isHistory ? Icons.history_rounded : Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(isHistory ? 'Chưa có lịch sử đơn hàng' : 'Không có đơn hàng nào', style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(isHistory ? 'Các đơn hàng đã hoàn thành sẽ hiển thị ở đây' : 'Đơn hàng mới sẽ hiển thị ở đây', style: TextStyle(fontSize: 13, color: Colors.grey.shade400), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class OrderActionButtons extends StatelessWidget {
  final OrderStatus status;
  final VoidCallback? onPickup;
  final VoidCallback? onStartDelivery;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;
  final VoidCallback? onCall;

  const OrderActionButtons({super.key, required this.status, this.onPickup, this.onStartDelivery, this.onComplete, this.onCancel, this.onCall});

  @override
  Widget build(BuildContext context) {
    if (status.isCompleted) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone_rounded, size: 18),
                    label: const Text('Gọi điện', style: TextStyle(fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(foregroundColor: AppColor.cMain, padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: AppColor.cMain), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: buildPrimaryButton()),
              ],
            ),
            if (status != OrderStatus.delivered) ...[
              const SizedBox(height: 8),
              TextButton(onPressed: onCancel, child: Text('Hủy đơn hàng', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w500))),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildPrimaryButton() {
    String label;
    IconData icon;
    VoidCallback? onTap;

    switch (status) {
      case OrderStatus.confirmed:
        label = 'Đã lấy hàng';
        icon = Icons.inventory_2_rounded;
        onTap = onPickup;
        break;
      case OrderStatus.picking:
        label = 'Bắt đầu giao';
        icon = Icons.local_shipping_rounded;
        onTap = onStartDelivery;
        break;
      case OrderStatus.delivering:
        label = 'Hoàn thành';
        icon = Icons.check_circle_rounded;
        onTap = onComplete;
        break;
      default:
        label = 'Xử lý';
        icon = Icons.check;
        onTap = null;
    }

    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
    );
  }
}

class OrderAddressCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String name;
  final String phone;
  final String address;
  final VoidCallback? onCallTap;
  final VoidCallback? onMapTap;

  const OrderAddressCard({super.key, required this.title, required this.icon, required this.iconColor, required this.name, required this.phone, required this.address, this.onCallTap, this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: iconColor, size: 18)),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Row(children: [Icon(Icons.phone_rounded, size: 14, color: Colors.grey.shade400), const SizedBox(width: 6), Text(phone, style: TextStyle(color: Colors.grey.shade600, fontSize: 13))]),
          const SizedBox(height: 4),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade400), const SizedBox(width: 6), Expanded(child: Text(address, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)))]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onCallTap,
                icon: const Icon(Icons.phone_rounded, size: 16),
                label: const Text('Gọi điện'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColor.cMain, side: BorderSide(color: AppColor.cMain.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onMapTap,
                icon: const Icon(Icons.map_rounded, size: 16),
                label: const Text('Bản đồ'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColor.cMain, side: BorderSide(color: AppColor.cMain.withOpacity(0.5)), padding: const EdgeInsets.symmetric(vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class OrderItemsCard extends StatelessWidget {
  final List<OrderItemModel> items;

  const OrderItemsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColor.cMain.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.shopping_bag_rounded, color: AppColor.cMain, size: 18)),
            const SizedBox(width: 10),
            Text('Sản phẩm (${items.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) { return const Divider(height: 16); },
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(item.imageUrl, width: 56, height: 56, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
                      return Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.image_rounded, color: Colors.grey.shade400));
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('x${item.quantity}', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                      ],
                    ),
                  ),
                  Text('${formatter.format(item.price)}đ', style: TextStyle(color: AppColor.cMain, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class OrderPaymentSummary extends StatelessWidget {
  final double totalAmount;
  final double shippingFee;
  final String? note;

  const OrderPaymentSummary({super.key, required this.totalAmount, required this.shippingFee, this.note});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.payments_rounded, color: Colors.green, size: 18)),
            const SizedBox(width: 10),
            const Text('Thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Tiền hàng', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)), Text('${formatter.format(totalAmount)}đ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Phí vận chuyển', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)), Text('${formatter.format(shippingFee)}đ', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tổng thu hộ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('${formatter.format(totalAmount + shippingFee)}đ', style: TextStyle(color: AppColor.cMain, fontWeight: FontWeight.bold, fontSize: 18))]),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.withOpacity(0.3))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note_rounded, color: Colors.amber.shade700, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ghi chú', style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.w600, fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(note!, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OrderDetailHeader extends StatelessWidget {
  final ShipperOrderModel order;

  const OrderDetailHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColor.cMain.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.receipt_long_rounded, color: AppColor.cMain, size: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.orderCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(DateFormat('HH:mm - dd/MM/yyyy').format(order.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                  ],
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          if (order.deliveredAt != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text('Giao lúc: ${DateFormat('HH:mm - dd/MM/yyyy').format(order.deliveredAt!)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 13)),
              ]),
            ),
          ],
        ],
      ),
    );
  }
}