import 'package:meko_project/models/local/shipper_model.dart';
//
// enum ShipperStatus { initial, loading, loaded, error }
//
// class ShipperState {
//   final ShipperStatus status;
//   final List<ShipperOrderModel> activeOrders;
//   final List<ShipperOrderModel> historyOrders;
//   final int selectedTabIndex;
//   final String? errorMessage;
//
//   ShipperState({
//     this.status = ShipperStatus.initial,
//     this.activeOrders = const [],
//     this.historyOrders = const [],
//     this.selectedTabIndex = 0,
//     this.errorMessage,
//   });
//
//   ShipperState copyWith({
//     ShipperStatus? status,
//     List<ShipperOrderModel>? activeOrders,
//     List<ShipperOrderModel>? historyOrders,
//     int? selectedTabIndex,
//     String? errorMessage,
//   }) {
//     return ShipperState(
//       status: status ?? this.status,
//       activeOrders: activeOrders ?? this.activeOrders,
//       historyOrders: historyOrders ?? this.historyOrders,
//       selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }
//
//   List<ShipperOrderModel> get currentOrders {
//     return selectedTabIndex == 0 ? activeOrders : historyOrders;
//   }
// }


enum ShipperStatus { initial, loading, loaded, error }

class ShipperState {
  final ShipperStatus status;
  final List<ShipperOrderModel> activeOrders;
  final List<ShipperOrderModel> historyOrders;
  final int selectedTabIndex;
  final String? errorMessage;

  ShipperState({
    this.status = ShipperStatus.initial,
    this.activeOrders = const [],
    this.historyOrders = const [],
    this.selectedTabIndex = 0,
    this.errorMessage,
  });

  ShipperState copyWith({
    ShipperStatus? status,
    List<ShipperOrderModel>? activeOrders,
    List<ShipperOrderModel>? historyOrders,
    int? selectedTabIndex,
    String? errorMessage,
  }) {
    return ShipperState(
      status: status ?? this.status,
      activeOrders: activeOrders ?? this.activeOrders,
      historyOrders: historyOrders ?? this.historyOrders,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<ShipperOrderModel> get currentOrders {
    return selectedTabIndex == 0 ? activeOrders : historyOrders;
  }
}
