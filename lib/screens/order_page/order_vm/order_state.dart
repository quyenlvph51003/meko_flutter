import 'package:equatable/equatable.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/local/shipper_model.dart';

enum OrderFormStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final ListingItem item;
  final String name;
  final String phone;
  final String address;
  final String note;
  final int quantity;
  final int paymentMethod;
  final OrderFormStatus status;
  final String? errorMessage;
  final ShipperOrderModel? createdOrder;

  const OrderState({
    required this.item,
    this.name = '',
    this.phone = '',
    this.address = '',
    this.note = '',
    this.quantity = 1,
    this.paymentMethod = 0,
    this.status = OrderFormStatus.initial,
    this.errorMessage,
    this.createdOrder,
  });

  double get unitPrice => double.tryParse(item.price) ?? 0;

  double get totalPrice => unitPrice * quantity;

  bool get isValid => name.isNotEmpty && phone.isNotEmpty && address.isNotEmpty;

  OrderState copyWith({
    ListingItem? item,
    String? name,
    String? phone,
    String? address,
    String? note,
    int? quantity,
    int? paymentMethod,
    OrderFormStatus? status,
    String? errorMessage,
    ShipperOrderModel? createdOrder,
  }) {
    return OrderState(
      item: item ?? this.item,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      note: note ?? this.note,
      quantity: quantity ?? this.quantity,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      errorMessage: errorMessage,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }

  @override
  List<Object?> get props => [
    item,
    name,
    phone,
    address,
    note,
    quantity,
    paymentMethod,
    status,
    errorMessage,
    createdOrder,
  ];
}