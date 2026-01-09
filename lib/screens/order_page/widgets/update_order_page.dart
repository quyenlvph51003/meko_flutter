import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/ghn/ghn_district.dart';
import 'package:meko_project/models/body/ghn/ghn_province.dart';
import 'package:meko_project/models/body/ghn/ghn_ward.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/models/body/order/update_order_request.dart';
import 'package:meko_project/repository/order/order_repo.dart';
import 'package:meko_project/screens/order_page/widgets/address_picker_bottom_sheet.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';

class UpdateOrderPage extends StatefulWidget {
  final OrderResponse order;

  const UpdateOrderPage({super.key, required this.order});

  @override
  State<UpdateOrderPage> createState() => _UpdateOrderPageState();
}

class _UpdateOrderPageState extends State<UpdateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _orderRepo = getIt<OrderRepository>();

  // Controllers
  late TextEditingController _customerNameController;
  late TextEditingController _customerPhoneController;
  late TextEditingController _customerAddressController;

  // Address selection
  GHNProvince? _selectedProvince;
  GHNDistrict? _selectedDistrict;
  GHNWard? _selectedWard;
  String _selectedAddressDisplay = '';

  // States
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _customerNameController = TextEditingController(text: widget.order.customerName);
    _customerPhoneController = TextEditingController(text: widget.order.customerPhone);
    _customerAddressController = TextEditingController(text: widget.order.customerAddress);

    // Build current address display
    final parts = <String>[];
    if (widget.order.toWardName != null) parts.add(widget.order.toWardName!);
    if (widget.order.toDistrictName != null) parts.add(widget.order.toDistrictName!);
    if (widget.order.toProvinceName != null) parts.add(widget.order.toProvinceName!);
    _selectedAddressDisplay = parts.join(', ');
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickAddress() async {
    final result = await AddressPickerBottomSheet.show(context);
    if (result != null) {
      setState(() {
        _selectedProvince = result.province;
        _selectedDistrict = result.district;
        _selectedWard = result.ward;
        _selectedAddressDisplay = result.fullAddress;
      });
    }
  }

  Future<void> _updateOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = UpdateOrderRequest(
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        customerAddress: _customerAddressController.text,
        toProvinceId: _selectedProvince?.provinceId ?? widget.order.toProvinceId,
        toDistrictId: _selectedDistrict?.districtId ?? widget.order.toDistrictId,
        toWardCode: _selectedWard?.wardCode ?? widget.order.toWardCode,
        subtotalAmount: widget.order.subtotalAmount,
        shippingFee: widget.order.shippingFee,
        totalAmount: widget.order.totalAmount,
        paymentMethod: widget.order.paymentMethod,
      );

      final response = await _orderRepo.updateOrder(widget.order.id, request);

      if (response.success) {
        Fluttertoast.showToast(
          msg: 'Cập nhật đơn hàng thành công',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        Fluttertoast.showToast(
          msg: response.message ?? 'Cập nhật đơn hàng thất bại',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Có lỗi xảy ra: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sửa đơn hàng',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin đơn hàng
              _buildOrderInfoSection(),
              const SizedBox(height: 16),

              // Thông tin người nhận
              _buildReceiverInfoSection(),
              const SizedBox(height: 24),

              // Update button
              _buildUpdateButton(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.cMain.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColor.cMain, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoSection() {
    return _buildSectionCard(
      title: 'Thông tin đơn hàng',
      icon: Icons.receipt_outlined,
      child: Column(
        children: [
          _buildInfoRow('Mã đơn hàng', widget.order.orderCode),
          const SizedBox(height: 12),
          _buildInfoRow('Tổng tiền', FormatUtils.formatCurrency(widget.order.totalAmount), valueColor: Colors.red),
          const SizedBox(height: 12),
          _buildInfoRow('Phương thức thanh toán', widget.order.paymentMethod),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiverInfoSection() {
    return _buildSectionCard(
      title: 'Thông tin người nhận',
      icon: Icons.person_outline,
      child: Column(
        children: [
          // Tên người nhận
          TextFormField(
            controller: _customerNameController,
            decoration: _buildInputDecoration('Tên người nhận *', Icons.person_outline),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập tên người nhận';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // SĐT người nhận
          TextFormField(
            controller: _customerPhoneController,
            decoration: _buildInputDecoration('Số điện thoại *', Icons.phone_outlined),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập số điện thoại';
              if (value.length < 10) return 'Số điện thoại không hợp lệ';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Địa chỉ chi tiết
          TextFormField(
            controller: _customerAddressController,
            decoration: _buildInputDecoration('Địa chỉ chi tiết *', Icons.home_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập địa chỉ chi tiết';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Chọn tỉnh/huyện/xã
          GestureDetector(
            onTap: _pickAddress,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedAddressDisplay.isNotEmpty
                          ? _selectedAddressDisplay
                          : 'Chọn Tỉnh/Huyện/Xã *',
                      style: TextStyle(
                        color: _selectedAddressDisplay.isNotEmpty ? Colors.black87 : Colors.grey[500],
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _updateOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.cMain,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: AppColor.cMain.withOpacity(0.6),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Cập nhật đơn hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor.cMain, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
