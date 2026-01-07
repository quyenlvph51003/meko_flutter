class OrderRequest {
  final int sellerId;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final int subtotalAmount;
  final int shippingFee;
  final int totalAmount;
  final int toProvinceId;
  final int toDistrictId;
  final String toWardCode;
  final int? postId;

  OrderRequest({
    required this.sellerId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.subtotalAmount,
    required this.shippingFee,
    required this.totalAmount,
    required this.toProvinceId,
    required this.toDistrictId,
    required this.toWardCode,
    this.postId,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
      sellerId: json['seller_id'] as int,
      customerId: json['customer_id'] as int,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      customerAddress: json['customer_address'] as String,
      subtotalAmount: json['subtotal_amount'] as int,
      shippingFee: json['shipping_fee'] as int,
      totalAmount: json['total_amount'] as int,
      toProvinceId: json['to_province_id'] as int,
      toDistrictId: json['to_district_id'] as int,
      toWardCode: json['to_ward_code'] as String,
      postId: json['post_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'seller_id': sellerId,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'subtotal_amount': subtotalAmount,
      'shipping_fee': shippingFee,
      'total_amount': totalAmount,
      'to_province_id': toProvinceId,
      'to_district_id': toDistrictId,
      'to_ward_code': toWardCode,
    };
    if (postId != null) {
      map['post_id'] = postId;
    }
    return map;
  }

  OrderRequest copyWith({
    int? sellerId,
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    int? subtotalAmount,
    int? shippingFee,
    int? totalAmount,
    int? toProvinceId,
    int? toDistrictId,
    String? toWardCode,
    int? postId,
  }) {
    return OrderRequest(
      sellerId: sellerId ?? this.sellerId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      shippingFee: shippingFee ?? this.shippingFee,
      totalAmount: totalAmount ?? this.totalAmount,
      toProvinceId: toProvinceId ?? this.toProvinceId,
      toDistrictId: toDistrictId ?? this.toDistrictId,
      toWardCode: toWardCode ?? this.toWardCode,
      postId: postId ?? this.postId,
    );
  }

  @override
  String toString() {
    return 'CreateOrderRequest(sellerId: $sellerId, customerId: $customerId, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, subtotalAmount: $subtotalAmount, shippingFee: $shippingFee, totalAmount: $totalAmount, toProvinceId: $toProvinceId, toDistrictId: $toDistrictId, toWardCode: $toWardCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderRequest &&
        other.sellerId == sellerId &&
        other.customerId == customerId &&
        other.customerName == customerName &&
        other.customerPhone == customerPhone &&
        other.customerAddress == customerAddress &&
        other.subtotalAmount == subtotalAmount &&
        other.shippingFee == shippingFee &&
        other.totalAmount == totalAmount &&
        other.toProvinceId == toProvinceId &&
        other.toDistrictId == toDistrictId &&
        other.toWardCode == toWardCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      sellerId,
      customerId,
      customerName,
      customerPhone,
      customerAddress,
      subtotalAmount,
      shippingFee,
      totalAmount,
      toProvinceId,
      toDistrictId,
      toWardCode,
    );
  }
}