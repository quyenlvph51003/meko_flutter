class ConfirmOrderRequest {
  final bool mock;
  final int serviceTypeId;
  final int weight;
  final int length;
  final int width;
  final int height;
  final String requiredNote;
  final String content;
  final int paymentTypeId;
  final String fromName;
  final String fromPhone;
  final String fromAddress;
  final int fromProvinceId;
  final int fromDistrictId;
  final String fromWardCode;
  final int toDistrictId;
  final String toWardCode;
  final int toProvinceId;

  ConfirmOrderRequest({
    this.mock = false,
    this.serviceTypeId = 2,
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
    this.requiredNote = 'KHONGCHOXEMHANG',
    this.content = 'Vận đơn GHN',
    this.paymentTypeId = 2,
    required this.fromName,
    required this.fromPhone,
    required this.fromAddress,
    required this.fromProvinceId,
    required this.fromDistrictId,
    required this.fromWardCode,
    required this.toDistrictId,
    required this.toWardCode,
    required this.toProvinceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'mock': mock,
      'service_type_id': serviceTypeId,
      'weight': weight,
      'length': length,
      'width': width,
      'height': height,
      'required_note': requiredNote,
      'content': content,
      'payment_type_id': paymentTypeId,
      'from_name': fromName,
      'from_phone': fromPhone,
      'from_address': fromAddress,
      'from_province_id': fromProvinceId,
      'from_district_id': fromDistrictId,
      'from_ward_code': fromWardCode,
      'to_district_id': toDistrictId,
      'to_ward_code': toWardCode,
      'to_province_id': toProvinceId,
    };
  }

  factory ConfirmOrderRequest.fromJson(Map<String, dynamic> json) {
    return ConfirmOrderRequest(
      mock: json['mock'] ?? false,
      serviceTypeId: json['service_type_id'] ?? 2,
      weight: json['weight'] ?? 0,
      length: json['length'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      requiredNote: json['required_note'] ?? 'KHONGCHOXEMHANG',
      content: json['content'] ?? 'Vận đơn GHN',
      paymentTypeId: json['payment_type_id'] ?? 2,
      fromName: json['from_name'] ?? '',
      fromPhone: json['from_phone'] ?? '',
      fromAddress: json['from_address'] ?? '',
      fromProvinceId: json['from_province_id'] ?? 0,
      fromDistrictId: json['from_district_id'] ?? 0,
      fromWardCode: json['from_ward_code'] ?? '',
      toDistrictId: json['to_district_id'] ?? 0,
      toWardCode: json['to_ward_code'] ?? '',
      toProvinceId: json['to_province_id'] ?? 0,
    );
  }
}

/// Enum cho required_note
enum RequiredNoteType {
  khongChoxemHang('KHONGCHOXEMHANG', 'Không cho xem hàng'),
  choThuhang('CHOTHUHANG', 'Cho thử hàng'),
  choXemKhongThu('CHOXEMHANGKHONGTHU', 'Cho xem hàng không thử');

  final String value;
  final String displayName;

  const RequiredNoteType(this.value, this.displayName);
}

/// Enum cho service_type_id
enum ServiceType {
  express(2, 'Giao hàng nhanh'),
  standard(5, 'Giao hàng tiêu chuẩn');

  final int value;
  final String displayName;

  const ServiceType(this.value, this.displayName);
}

/// Enum cho payment_type_id
enum PaymentType {
  sellerPay(1, 'Người gửi trả phí'),
  buyerPay(2, 'Người nhận trả phí');

  final int value;
  final String displayName;

  const PaymentType(this.value, this.displayName);
}
