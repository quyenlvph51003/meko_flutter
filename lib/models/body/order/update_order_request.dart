/// Request model để cập nhật thông tin đơn hàng (cho buyer khi đơn chờ xác nhận)
class UpdateOrderRequest {
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final double? subtotalAmount;
  final double? shippingFee;
  final double? totalAmount;
  final int? toProvinceId;
  final int? toDistrictId;
  final String? toWardCode;
  final String? paymentMethod;

  UpdateOrderRequest({
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.subtotalAmount,
    this.shippingFee,
    this.totalAmount,
    this.toProvinceId,
    this.toDistrictId,
    this.toWardCode,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (customerName != null) data['customer_name'] = customerName;
    if (customerPhone != null) data['customer_phone'] = customerPhone;
    if (customerAddress != null) data['customer_address'] = customerAddress;
    if (subtotalAmount != null) data['subtotal_amount'] = subtotalAmount;
    if (shippingFee != null) data['shipping_fee'] = shippingFee;
    if (totalAmount != null) data['total_amount'] = totalAmount;
    if (toProvinceId != null) data['to_province_id'] = toProvinceId;
    if (toDistrictId != null) data['to_district_id'] = toDistrictId;
    if (toWardCode != null) data['to_ward_code'] = toWardCode;
    if (paymentMethod != null) data['payment_method'] = paymentMethod;
    return data;
  }
}
