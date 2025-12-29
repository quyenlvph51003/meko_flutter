// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meko_project/consts/app_colcor.dart';
// import 'package:meko_project/models/local/shipper_model.dart';
// import 'package:meko_project/screens/shipper_page/shipper_vm/shipper_cubit.dart';
// import 'package:meko_project/screens/shipper_page/shipper_vm/shipper_state.dart';
// import 'package:meko_project/screens/shipper_page/widget/shipper_widgets.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ShipperScreen extends StatelessWidget {
//   const ShipperScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) { return ShipperCubit()..loadOrders(); },
//       child: const ShipperScreenContent(),
//     );
//   }
// }
//
// class ShipperScreenContent extends StatelessWidget {
//   const ShipperScreenContent({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: AppColor.cMain,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text('Đơn hàng của tôi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//         actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.white))],
//       ),
//       body: BlocBuilder<ShipperCubit, ShipperState>(
//         builder: (context, state) {
//           if (state.status == ShipperStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.status == ShipperStatus.error) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(32),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
//                     const SizedBox(height: 16),
//                     Text(state.errorMessage ?? 'Đã có lỗi xảy ra', style: TextStyle(fontSize: 16, color: Colors.grey.shade600), textAlign: TextAlign.center),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: () { context.read<ShipperCubit>().loadOrders(); },
//                       style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//                       child: const Text('Thử lại'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//           return Column(
//             children: [
//               ShipperTabBar(
//                 selectedIndex: state.selectedTabIndex,
//                 activeCount: state.activeOrders.length,
//                 historyCount: state.historyOrders.length,
//                 onTabChanged: (index) { context.read<ShipperCubit>().changeTab(index); },
//               ),
//               Expanded(
//                 child: state.currentOrders.isEmpty
//                     ? EmptyOrderState(isHistory: state.selectedTabIndex == 1)
//                     : RefreshIndicator(
//                   onRefresh: () { return context.read<ShipperCubit>().loadOrders(); },
//                   color: AppColor.cMain,
//                   child: ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     itemCount: state.currentOrders.length,
//                     itemBuilder: (context, index) {
//                       final order = state.currentOrders[index];
//                       return ShipperOrderCard(
//                         order: order,
//                         onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) { return ShipperOrderDetailScreen(order: order); })); },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class ShipperOrderDetailScreen extends StatelessWidget {
//   final ShipperOrderModel order;
//
//   const ShipperOrderDetailScreen({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) { return ShipperCubit()..loadOrders(); },
//       child: ShipperOrderDetailContent(order: order),
//     );
//   }
// }
//
// class ShipperOrderDetailContent extends StatefulWidget {
//   final ShipperOrderModel order;
//
//   const ShipperOrderDetailContent({super.key, required this.order});
//
//   @override
//   State<ShipperOrderDetailContent> createState() { return ShipperOrderDetailContentState(); }
// }
//
// class ShipperOrderDetailContentState extends State<ShipperOrderDetailContent> {
//   late ShipperOrderModel currentOrder;
//
//   @override
//   void initState() {
//     super.initState();
//     currentOrder = widget.order;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<ShipperCubit, ShipperState>(
//       listener: (context, state) {
//         final updatedOrder = [...state.activeOrders, ...state.historyOrders].where((o) { return o.id == currentOrder.id; }).firstOrNull;
//         if (updatedOrder != null) {
//           setState(() { currentOrder = updatedOrder; });
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           backgroundColor: AppColor.cMain,
//           elevation: 0,
//           centerTitle: true,
//           leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
//           title: const Text('Chi tiết đơn hàng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               OrderDetailHeader(order: currentOrder),
//               OrderAddressCard(
//                 title: 'Địa chỉ lấy hàng',
//                 icon: Icons.store_rounded,
//                 iconColor: Colors.orange,
//                 name: currentOrder.sellerName,
//                 phone: currentOrder.sellerPhone,
//                 address: currentOrder.sellerAddress,
//                 onCallTap: () { makePhoneCall(currentOrder.sellerPhone); },
//                 onMapTap: () { openMap(currentOrder.sellerAddress); },
//               ),
//               OrderAddressCard(
//                 title: 'Địa chỉ giao hàng',
//                 icon: Icons.location_on_rounded,
//                 iconColor: AppColor.cMain,
//                 name: currentOrder.customerName,
//                 phone: currentOrder.customerPhone,
//                 address: currentOrder.customerAddress,
//                 onCallTap: () { makePhoneCall(currentOrder.customerPhone); },
//                 onMapTap: () { openMap(currentOrder.customerAddress); },
//               ),
//               OrderItemsCard(items: currentOrder.items),
//               OrderPaymentSummary(totalAmount: currentOrder.totalAmount, shippingFee: currentOrder.shippingFee, note: currentOrder.note),
//               const SizedBox(height: 100),
//             ],
//           ),
//         ),
//         bottomNavigationBar: OrderActionButtons(
//           status: currentOrder.status,
//           onPickup: () { showConfirmDialog(title: 'Xác nhận lấy hàng', message: 'Bạn đã lấy hàng từ người bán?', onConfirm: () { context.read<ShipperCubit>().confirmPickup(currentOrder.id); }); },
//           onStartDelivery: () { showConfirmDialog(title: 'Bắt đầu giao hàng', message: 'Bạn đang trên đường giao hàng cho khách?', onConfirm: () { context.read<ShipperCubit>().startDelivery(currentOrder.id); }); },
//           onComplete: () { showConfirmDialog(title: 'Hoàn thành đơn hàng', message: 'Xác nhận đã giao hàng thành công?', onConfirm: () { context.read<ShipperCubit>().completeDelivery(currentOrder.id); Navigator.pop(context); }); },
//           onCancel: () { showCancelDialog(); },
//           onCall: () { makePhoneCall(currentOrder.customerPhone); },
//         ),
//       ),
//     );
//   }
//
//   void showConfirmDialog({required String title, required String message, required VoidCallback onConfirm}) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//           content: Text(message),
//           actions: [
//             TextButton(onPressed: () { Navigator.pop(context); }, child: Text('Hủy', style: TextStyle(color: Colors.grey.shade600))),
//             ElevatedButton(
//               onPressed: () { Navigator.pop(context); onConfirm(); },
//               style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//               child: const Text('Xác nhận'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void showCancelDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           title: const Text('Hủy đơn hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
//           content: const Text('Bạn có chắc muốn hủy đơn hàng này?'),
//           actions: [
//             TextButton(onPressed: () { Navigator.pop(context); }, child: Text('Không', style: TextStyle(color: Colors.grey.shade600))),
//             ElevatedButton(
//               onPressed: () { Navigator.pop(context); context.read<ShipperCubit>().cancelOrder(currentOrder.id); Navigator.pop(context); },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
//               child: const Text('Hủy đơn'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     }
//   }
//
//   Future<void> openMap(String address) async {
//     final Uri launchUri = Uri(scheme: 'https', host: 'www.google.com', path: '/maps/search/', queryParameters: {'q': address});
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/models/local/shipper_model.dart';
import 'package:meko_project/screens/shipper_page/shipper_vm/shipper_cubit.dart';
import 'package:meko_project/screens/shipper_page/shipper_vm/shipper_state.dart';
import 'package:meko_project/screens/shipper_page/widget/shipper_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ShipperScreen extends StatelessWidget {
  const ShipperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) { return ShipperCubit()..loadOrders(); },
      child: const ShipperScreenContent(),
    );
  }
}

class ShipperScreenContent extends StatefulWidget {
  const ShipperScreenContent({super.key});

  @override
  State<ShipperScreenContent> createState() { return ShipperScreenContentState(); }
}

class ShipperScreenContentState extends State<ShipperScreenContent> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pageController = PageController();
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColor.cMain,
        elevation: 0,
        centerTitle: true,
        title: const Text('Đơn hàng của tôi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.white))],
      ),
      body: BlocBuilder<ShipperCubit, ShipperState>(
        builder: (context, state) {
          if (state.status == ShipperStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ShipperStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? 'Đã có lỗi xảy ra', style: TextStyle(fontSize: 16, color: Colors.grey.shade600), textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () { context.read<ShipperCubit>().loadOrders(); },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }
          return Column(
            children: [
              ShipperTabBar(
                tabController: tabController,
                activeCount: state.activeOrders.length,
                historyCount: state.historyOrders.length,
                onTabChanged: (index) {
                  pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                },
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    tabController.animateTo(index);
                    context.read<ShipperCubit>().changeTab(index);
                  },
                  children: [
                    buildOrderList(context, state.activeOrders, false),
                    buildOrderList(context, state.historyOrders, true),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildOrderList(BuildContext context, List<ShipperOrderModel> orders, bool isHistory) {
    if (orders.isEmpty) {
      return EmptyOrderState(isHistory: isHistory);
    }
    return RefreshIndicator(
      onRefresh: () { return context.read<ShipperCubit>().loadOrders(); },
      color: AppColor.cMain,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ShipperOrderCard(
            order: order,
            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) { return ShipperOrderDetailScreen(order: order); })); },
          );
        },
      ),
    );
  }
}

class ShipperOrderDetailScreen extends StatelessWidget {
  final ShipperOrderModel order;

  const ShipperOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) { return ShipperCubit()..loadOrders(); },
      child: ShipperOrderDetailContent(order: order),
    );
  }
}

class ShipperOrderDetailContent extends StatefulWidget {
  final ShipperOrderModel order;

  const ShipperOrderDetailContent({super.key, required this.order});

  @override
  State<ShipperOrderDetailContent> createState() { return ShipperOrderDetailContentState(); }
}

class ShipperOrderDetailContentState extends State<ShipperOrderDetailContent> {
  late ShipperOrderModel currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShipperCubit, ShipperState>(
      listener: (context, state) {
        final updatedOrder = [...state.activeOrders, ...state.historyOrders].where((o) { return o.id == currentOrder.id; }).firstOrNull;
        if (updatedOrder != null) {
          setState(() { currentOrder = updatedOrder; });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: AppColor.cMain,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(onPressed: () { Navigator.pop(context); }, icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)),
          title: const Text('Chi tiết đơn hàng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              OrderDetailHeader(order: currentOrder),
              OrderAddressCard(
                title: 'Địa chỉ lấy hàng',
                icon: Icons.store_rounded,
                iconColor: Colors.orange,
                name: currentOrder.sellerName,
                phone: currentOrder.sellerPhone,
                address: currentOrder.sellerAddress,
                onCallTap: () { makePhoneCall(currentOrder.sellerPhone); },
                onMapTap: () { openMap(currentOrder.sellerAddress); },
              ),
              OrderAddressCard(
                title: 'Địa chỉ giao hàng',
                icon: Icons.location_on_rounded,
                iconColor: AppColor.cMain,
                name: currentOrder.customerName,
                phone: currentOrder.customerPhone,
                address: currentOrder.customerAddress,
                onCallTap: () { makePhoneCall(currentOrder.customerPhone); },
                onMapTap: () { openMap(currentOrder.customerAddress); },
              ),
              OrderItemsCard(items: currentOrder.items),
              OrderPaymentSummary(totalAmount: currentOrder.totalAmount, shippingFee: currentOrder.shippingFee, note: currentOrder.note),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: OrderActionButtons(
          status: currentOrder.status,
          onPickup: () { showConfirmDialog(title: 'Xác nhận lấy hàng', message: 'Bạn đã lấy hàng từ người bán?', onConfirm: () { context.read<ShipperCubit>().confirmPickup(currentOrder.id); }); },
          onStartDelivery: () { showConfirmDialog(title: 'Bắt đầu giao hàng', message: 'Bạn đang trên đường giao hàng cho khách?', onConfirm: () { context.read<ShipperCubit>().startDelivery(currentOrder.id); }); },
          onComplete: () { showConfirmDialog(title: 'Hoàn thành đơn hàng', message: 'Xác nhận đã giao hàng thành công?', onConfirm: () { context.read<ShipperCubit>().completeDelivery(currentOrder.id); Navigator.pop(context); }); },
          onCancel: () { showCancelDialog(); },
          onCall: () { makePhoneCall(currentOrder.customerPhone); },
        ),
      ),
    );
  }

  void showConfirmDialog({required String title, required String message, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Text(message),
          actions: [
            TextButton(onPressed: () { Navigator.pop(context); }, child: Text('Hủy', style: TextStyle(color: Colors.grey.shade600))),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); onConfirm(); },
              style: ElevatedButton.styleFrom(backgroundColor: AppColor.cMain, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  void showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Hủy đơn hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
          content: const Text('Bạn có chắc muốn hủy đơn hàng này?'),
          actions: [
            TextButton(onPressed: () { Navigator.pop(context); }, child: Text('Không', style: TextStyle(color: Colors.grey.shade600))),
            ElevatedButton(
              onPressed: () { Navigator.pop(context); context.read<ShipperCubit>().cancelOrder(currentOrder.id); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: const Text('Hủy đơn'),
            ),
          ],
        );
      },
    );
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> openMap(String address) async {
    final Uri launchUri = Uri(scheme: 'https', host: 'www.google.com', path: '/maps/search/', queryParameters: {'q': address});
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}