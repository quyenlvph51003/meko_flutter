import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/ghn/ghn_district.dart';
import 'package:meko_project/models/body/ghn/ghn_province.dart';
import 'package:meko_project/models/body/ghn/ghn_ward.dart';
import 'package:meko_project/models/body/order/confirm_order_request.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/repository/order/order_repo.dart';
import 'package:meko_project/screens/order_page/widgets/address_picker_bottom_sheet.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class ConfirmOrderPage extends StatefulWidget {
  final OrderResponse order;

  const ConfirmOrderPage({super.key, required this.order});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _orderRepo = getIt<OrderRepository>();

  // Controllers
  final _fromNameController = TextEditingController();
  final _fromPhoneController = TextEditingController();
  final _fromAddressController = TextEditingController();
  final _weightController = TextEditingController(text: '500');
  final _lengthController = TextEditingController(text: '10');
  final _widthController = TextEditingController(text: '10');
  final _heightController = TextEditingController(text: '5');
  final _contentController = TextEditingController(text: 'Vận đơn GHN');

  // Address selection
  GHNProvince? _selectedProvince;
  GHNDistrict? _selectedDistrict;
  GHNWard? _selectedWard;
  String _selectedAddressDisplay = '';

  // Options - chỉ giữ lại ghi chú giao hàng
  RequiredNoteType _selectedRequiredNote = RequiredNoteType.khongChoxemHang;

  // States
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSellerInfo();
  }

  Future<void> _loadSellerInfo() async {
    final user = await SqliteHelper.getUserSql();
    if (user != null && mounted) {
      setState(() {
        _fromNameController.text = user.username ?? '';
        // Nếu cần SĐT, có thể lấy từ email hoặc để trống để user nhập
      });
    }
  }

  @override
  void dispose() {
    _fromNameController.dispose();
    _fromPhoneController.dispose();
    _fromAddressController.dispose();
    _weightController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _contentController.dispose();
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

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProvince == null || _selectedDistrict == null || _selectedWard == null) {
      Fluttertoast.showToast(
        msg: 'Vui lòng chọn địa chỉ người gửi',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final request = ConfirmOrderRequest(
        mock: true, // Set cứng mock = true
        serviceTypeId: 2, // Set cứng service_type_id = 2 (Giao hàng nhanh)
        weight: int.tryParse(_weightController.text) ?? 500,
        length: int.tryParse(_lengthController.text) ?? 10,
        width: int.tryParse(_widthController.text) ?? 10,
        height: int.tryParse(_heightController.text) ?? 5,
        requiredNote: _selectedRequiredNote.value,
        content: _contentController.text.isNotEmpty ? _contentController.text : 'Vận đơn GHN',
        paymentTypeId: 2, // Set cứng payment_type_id = 2 (Người nhận trả phí)
        fromName: _fromNameController.text,
        fromPhone: _fromPhoneController.text,
        fromAddress: _fromAddressController.text,
        fromProvinceId: _selectedProvince!.provinceId,
        fromDistrictId: _selectedDistrict!.districtId,
        fromWardCode: _selectedWard!.wardCode,
        toDistrictId: widget.order.toDistrictId ?? 0,
        toWardCode: widget.order.toWardCode ?? '',
        toProvinceId: widget.order.toProvinceId ?? 0,
      );

      final response = await _orderRepo.confirmOrderGHN(widget.order.id, request);

      if (response.success) {
        Fluttertoast.showToast(
          msg: 'Xác nhận đơn hàng thành công',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        Fluttertoast.showToast(
          msg: response.message ?? 'Xác nhận đơn hàng thất bại',
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
          'Xác nhận đơn hàng',
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

              // Thông tin người gửi
              _buildSenderInfoSection(),
              const SizedBox(height: 16),

              // Thông tin kiện hàng
              _buildPackageInfoSection(),
              const SizedBox(height: 24),

              // Confirm button
              _buildConfirmButton(),
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
          _buildInfoRow('Người nhận', widget.order.customerName),
          const SizedBox(height: 12),
          _buildInfoRow('SĐT người nhận', widget.order.customerPhone),
          const SizedBox(height: 12),
          _buildInfoRow('Địa chỉ nhận', _buildReceiverAddress()),
          const SizedBox(height: 12),
          _buildInfoRow('Tổng tiền', FormatUtils.formatCurrency(widget.order.totalAmount), valueColor: Colors.red),
        ],
      ),
    );
  }

  String _buildReceiverAddress() {
    final parts = <String>[];
    if (widget.order.customerAddress.isNotEmpty) parts.add(widget.order.customerAddress);
    if (widget.order.toWardName != null) parts.add(widget.order.toWardName!);
    if (widget.order.toDistrictName != null) parts.add(widget.order.toDistrictName!);
    if (widget.order.toProvinceName != null) parts.add(widget.order.toProvinceName!);
    return parts.join(', ');
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
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

  Widget _buildSenderInfoSection() {
    return _buildSectionCard(
      title: 'Thông tin người gửi',
      icon: Icons.store,
      child: Column(
        children: [
          // Tên người gửi
          TextFormField(
            controller: _fromNameController,
            decoration: _buildInputDecoration('Tên người gửi *', Icons.person_outline),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập tên người gửi';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // SĐT người gửi
          TextFormField(
            controller: _fromPhoneController,
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
            controller: _fromAddressController,
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

  Widget _buildPackageInfoSection() {
    return _buildSectionCard(
      title: 'Thông tin kiện hàng',
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          // Cân nặng
          TextFormField(
            controller: _weightController,
            decoration: _buildInputDecoration('Cân nặng (gram) *', Icons.fitness_center),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập cân nặng';
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Kích thước
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _lengthController,
                  decoration: _buildInputDecoration('Dài (cm)', Icons.straighten),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _widthController,
                  decoration: _buildInputDecoration('Rộng (cm)', Icons.straighten),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _heightController,
                  decoration: _buildInputDecoration('Cao (cm)', Icons.straighten),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Nội dung hàng
          TextFormField(
            controller: _contentController,
            decoration: _buildInputDecoration('Nội dung hàng', Icons.description_outlined),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _confirmOrder,
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
                'Xác nhận tạo vận đơn GHN',
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
