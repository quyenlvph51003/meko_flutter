import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/order/order_repo.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_button/app_button.dart';

import 'order_vm/order_cubit.dart';
import 'order_vm/order_state.dart';
import 'order_vm/widget/order_detail.dart';
import 'widgets/address_picker_bottom_sheet.dart';

class OrderPage extends StatelessWidget {
  final ListingItem item;

  const OrderPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return OrderCubit(item: item, orderRepository: getIt<OrderRepository>())..loadUser();
      },
      child: OrderView(),
    );
  }
}

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, OrderState state) {
    final cubit = context.read<OrderCubit>(); // Lưu reference trước
    final orderCode = state.createdOrder?.orderCode ?? '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColor.cMain.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColor.cMain, size: 50),
              ),
              const SizedBox(height: 16),
              const Text(
                'Đặt hàng thành công!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Mã đơn hàng: $orderCode',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.cMain,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Đơn hàng của bạn đã được gửi đến người bán',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onTap: () {
                    Navigator.pop(ctx); // Đóng dialog
                    final item = state.item;
                    cubit.loadOrderByCode(orderCode); // Load trước
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailPage(
                          orderCode: orderCode,
                          productImage: item?.images.isNotEmpty == true ? item!.images.first : null,
                          productName: item?.title,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColor.cMain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Xem đơn hàng',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  onTap: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Tiếp tục mua sắm',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void navigateToDetail(BuildContext context, String orderCode) {
    context.read<OrderCubit>().loadOrderByCode(orderCode);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BlocProvider.value(
        value: context.read<OrderCubit>(),
        child: const OrderDetailView(),
      )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == OrderFormStatus.error && state.errorMessage != null) {
          Fluttertoast.showToast(msg: state.errorMessage!, backgroundColor: Colors.red);
          context.read<OrderCubit>().resetStatus();
        }
        if (state.status == OrderFormStatus.success) {
          showSuccessDialog(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Đặt hàng',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          buildWhen: (prev, curr) {
            if (prev.name != curr.name && nameController.text != curr.name) return true;
            if (prev.phone != curr.phone && phoneController.text != curr.phone) return true;
            if (prev.address != curr.address && addressController.text != curr.address) return true;
            return false;
          },
          builder: (context, state) {
            if (nameController.text != state.name && nameController.text.isEmpty) {
              nameController.text = state.name;
            }
            if (phoneController.text != state.phone && phoneController.text.isEmpty) {
              phoneController.text = state.phone;
            }
            if (addressController.text != state.address && addressController.text.isEmpty) {
              addressController.text = state.address;
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const ProductSection(),
                  const SizedBox(height: 8),
                  const SellerSection(),
                  const SizedBox(height: 8),
                  DeliverySection(
                    nameController: nameController,
                    phoneController: phoneController,
                    addressDetailController: addressController,
                  ),
                  const SizedBox(height: 8),
                  const PaymentSection(),
                  const SizedBox(height: 8),
                  NoteSection(noteController: noteController),
                  const SizedBox(height: 8),
                  const PriceSummarySection(),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: const OrderBottomBar(),
      ),
    );
  }
}

class ProductSection extends StatelessWidget {
  const ProductSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => prev.quantity != curr.quantity,
      builder: (context, state) {
        final item = state.item;
        final vm = context.read<OrderCubit>();
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin sản phẩm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item!.images.isNotEmpty ? item.images.first : '',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item!.title,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.categories.isNotEmpty ? item.categories.join(' / ') : '',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          FormatUtils.formatCurrency(state.unitPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Số lượng:', style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: vm.decreaseQuantity,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: state.quantity > 1 ? Colors.grey[100] : Colors.grey[50],
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(7)),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 18,
                              color: state.quantity > 1 ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              vertical: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Text(
                            '${state.quantity}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: vm.increaseQuantity,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(7),
                              ),
                            ),
                            child: const Icon(Icons.add, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SellerSection extends StatelessWidget {
  const SellerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => false,
      builder: (context, state) {
        final item = state.item;
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông tin người bán',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: item?.avatarPoster != null
                            ? NetworkImage(item!.avatarPoster!)
                            : const AssetImage(AppImages.img_avt_default) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item?.userNamePoster??'',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item!.address,
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class DeliverySection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressDetailController;

  const DeliverySection({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.addressDetailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OrderCubit>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 20, color: AppColor.cMain),
              const SizedBox(width: 8),
              const Text(
                'Thông tin nhận hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OrderTextField(
            controller: nameController,
            label: 'Họ và tên',
            hint: 'Nhập họ và tên người nhận',
            icon: Icons.person_outline,
            onChanged: vm.updateName,
          ),
          const SizedBox(height: 12),
          OrderTextField(
            controller: phoneController,
            label: 'Số điện thoại',
            hint: 'Nhập số điện thoại',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: vm.updatePhone,
          ),
          const SizedBox(height: 12),
          // Chọn Tỉnh/Huyện/Xã
          _AddressPickerField(),
          const SizedBox(height: 12),
          // Địa chỉ chi tiết (số nhà, đường)
          OrderTextField(
            controller: addressDetailController,
            label: 'Địa chỉ chi tiết',
            hint: 'Số nhà, tên đường...',
            icon: Icons.home_outlined,
            maxLines: 2,
            onChanged: vm.updateAddressDetail,
          ),
        ],
      ),
    );
  }
}

class _AddressPickerField extends StatelessWidget {
  const _AddressPickerField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => prev.address != curr.address,
      builder: (context, state) {
        final hasAddress = state.address.isNotEmpty;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tỉnh/Huyện/Xã',
              style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showAddressPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: hasAddress ? AppColor.cMain : Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: hasAddress ? AppColor.cMain : Colors.grey[500],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hasAddress ? state.address : 'Chọn Tỉnh/Thành phố, Quận/Huyện, Phường/Xã',
                        style: TextStyle(
                          fontSize: 14,
                          color: hasAddress ? Colors.black87 : Colors.grey[400],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddressPicker(BuildContext context) async {
    final result = await AddressPickerBottomSheet.show(context);
    if (result != null && context.mounted) {
      context.read<OrderCubit>().updateShippingAddress(
        provinceId: result.province.provinceId,
        districtId: result.district.districtId,
        wardCode: result.ward.wardCode,
        address: result.fullAddress,
      );
    }
  }
}

class OrderTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final Function(String) onChanged;

  const OrderTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
              prefixIcon: Icon(icon, size: 20, color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentSection extends StatelessWidget {
  const PaymentSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => prev.paymentMethod != curr.paymentMethod,
      builder: (context, state) {
        final vm = context.read<OrderCubit>();
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.payment_outlined, size: 20, color: AppColor.cMain),
                  const SizedBox(width: 8),
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PaymentOption(
                index: 0,
                icon: Icons.money,
                title: 'Thanh toán khi nhận hàng',
                subtitle: 'Thanh toán bằng tiền mặt',
                isSelected: state.paymentMethod == 0,
                onTap: () => vm.updatePaymentMethod(0),
              ),
              const SizedBox(height: 8),
              PaymentOption(
                index: 1,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Chuyển khoản ngân hàng',
                subtitle: 'Chuyển khoản trước khi giao',
                isSelected: state.paymentMethod == 1,
                onTap: () => vm.updatePaymentMethod(1),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentOption extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOption({
    Key? key,
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cMain.withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColor.cMain : Colors.grey[200]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.cMain.withOpacity(0.1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: isSelected ? AppColor.cMain : Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColor.cMain : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.cMain : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.cMain,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class NoteSection extends StatelessWidget {
  final TextEditingController noteController;

  const NoteSection({Key? key, required this.noteController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OrderCubit>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note_outlined, size: 20, color: AppColor.cMain),
              const SizedBox(width: 8),
              const Text('Ghi chú', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: TextField(
              controller: noteController,
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
              onChanged: vm.updateNote,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú cho người bán (không bắt buộc)',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PriceSummarySection extends StatelessWidget {
  const PriceSummarySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => prev.quantity != curr.quantity,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 20, color: AppColor.cMain),
                  const SizedBox(width: 8),
                  const Text(
                    'Chi tiết thanh toán',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PriceRow(label: 'Đơn giá', value: FormatUtils.formatCurrency(state.unitPrice)),
              const SizedBox(height: 8),
              PriceRow(label: 'Số lượng', value: 'x${state.quantity}'),
              const SizedBox(height: 8),
              const PriceRow(label: 'Phí vận chuyển', value: 'Liên hệ người bán'),
              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tổng thanh toán',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    FormatUtils.formatCurrency(state.totalPrice),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const PriceRow({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

class OrderBottomBar extends StatelessWidget {
  const OrderBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      buildWhen: (prev, curr) => prev.quantity != curr.quantity || prev.status != curr.status,
      builder: (context, state) {
        final isLoading = state.status == OrderFormStatus.loading;
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: AppDimens.getBottom(context) + 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng thanh toán',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FormatUtils.formatCurrency(state.totalPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: AppButton(
                  onTap: isLoading ? null : () => context.read<OrderCubit>().submitOrder(),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: isLoading ? Colors.grey : AppColor.cMain,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Đặt hàng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
