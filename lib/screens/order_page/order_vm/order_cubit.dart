import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/local/shipper_model.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required ListingItem item}) : super(OrderState(item: item));

  Future<void> loadUser() async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) return;

    emit(state.copyWith(
      name: user.username ?? '',
      address: user.addressName ?? '',
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

  void updateNote(String value) {
    if (state.note == value) return;
    emit(state.copyWith(note: value));
  }

  void updatePaymentMethod(int value) {
    if (state.paymentMethod == value) return;
    emit(state.copyWith(paymentMethod: value));
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
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: 'Vui lòng nhập địa chỉ'));
      return false;
    }

    emit(state.copyWith(status: OrderFormStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 2));

      final createdOrder = _createShipperOrder();

      emit(state.copyWith(
        status: OrderFormStatus.success,
        createdOrder: createdOrder,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(status: OrderFormStatus.error, errorMessage: e.toString()));
      return false;
    }
  }

  ShipperOrderModel _createShipperOrder() {
    final item = state.item;
    final now = DateTime.now();
    final orderCode = 'MK${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond}';

    return ShipperOrderModel(
      id: now.millisecondsSinceEpoch.toString(),
      orderCode: orderCode,
      customerName: state.name,
      customerPhone: state.phone,
      customerAddress: state.address,
      sellerName: item.userNamePoster,
      sellerPhone: item.phoneNumber ?? '',
      sellerAddress: item.address,
      items: [
        OrderItemModel(
          id: item.id.toString(),
          name: item.title,
          imageUrl: item.images.isNotEmpty ? item.images.first : '',
          quantity: state.quantity,
          price: state.unitPrice,
        ),
      ],
      totalAmount: state.totalPrice,
      shippingFee: 0,
      status: OrderStatus.confirmed,
      createdAt: now,
      note: state.note.isNotEmpty ? state.note : null,
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: OrderFormStatus.initial, errorMessage: null));
  }
}