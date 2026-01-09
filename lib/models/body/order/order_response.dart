class OrderResponse {
  final int id;
  final String orderCode;
  final int sellerId;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final int toProvinceId;
  final int toDistrictId;
  final String toWardCode;
  final double subtotalAmount;
  final double shippingFee;
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String shippingProvider;
  final String? ghnOrderCode;
  final String shippingStatus;
  final String orderStatus;
  final String? fromName;
  final String? fromPhone;
  final String? fromAddress;
  final int? fromDistrictId;
  final String? fromWardCode;
  final int? fromProvinceId;
  final int? weight;
  final int? length;
  final int? width;
  final int? height;
  final String? requiredNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Thông tin địa chỉ chi tiết
  final String? toProvinceName;
  final String? toDistrictName;
  final String? toWardName;
  final String? fromProvinceName;
  final String? fromDistrictName;
  final String? fromWardName;
  // Thông tin sản phẩm
  final String? productImage;
  final String? productName;
  final int? postId;

  OrderResponse({
    required this.id,
    required this.orderCode,
    required this.sellerId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.toProvinceId,
    required this.toDistrictId,
    required this.toWardCode,
    required this.subtotalAmount,
    required this.shippingFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.shippingProvider,
    this.ghnOrderCode,
    required this.shippingStatus,
    required this.orderStatus,
    this.fromName,
    this.fromPhone,
    this.fromAddress,
    this.fromDistrictId,
    this.fromWardCode,
    this.fromProvinceId,
    this.weight,
    this.length,
    this.width,
    this.height,
    this.requiredNote,
    required this.createdAt,
    required this.updatedAt,
    this.toProvinceName,
    this.toDistrictName,
    this.toWardName,
    this.fromProvinceName,
    this.fromDistrictName,
    this.fromWardName,
    this.productImage,
    this.productName,
    this.postId,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'] as int,
      orderCode: json['order_code'] as String,
      sellerId: json['seller_id'] as int,
      customerId: json['customer_id'] as int,
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      customerAddress: json['customer_address'] as String,
      toProvinceId: json['to_province_id'] as int,
      toDistrictId: json['to_district_id'] as int,
      toWardCode: json['to_ward_code'] as String,
      subtotalAmount: double.parse(json['subtotal_amount'] as String),
      shippingFee: double.parse(json['shipping_fee'] as String),
      totalAmount: double.parse(json['total_amount'] as String),
      paymentMethod: json['payment_method'] as String,
      paymentStatus: json['payment_status'] as String,
      shippingProvider: json['shipping_provider'] as String,
      ghnOrderCode: json['ghn_order_code'] as String?,
      shippingStatus: json['shipping_status'] as String,
      orderStatus: json['order_status'] as String,
      fromName: json['from_name'] as String?,
      fromPhone: json['from_phone'] as String?,
      fromAddress: json['from_address'] as String?,
      fromDistrictId: json['from_district_id'] as int?,
      fromWardCode: json['from_ward_code'] as String?,
      fromProvinceId: json['from_province_id'] as int?,
      weight: json['weight'] as int?,
      length: json['length'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      requiredNote: json['required_note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      toProvinceName: json['to_province_name'] as String?,
      toDistrictName: json['to_district_name'] as String?,
      toWardName: json['to_ward_name'] as String?,
      fromProvinceName: json['from_province_name'] as String?,
      fromDistrictName: json['from_district_name'] as String?,
      fromWardName: json['from_ward_name'] as String?,
      productImage: json['product_image'] as String? ?? json['post_image'] as String?,
      productName: json['product_name'] as String? ?? json['post_title'] as String?,
      postId: json['post_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'order_code': orderCode,
    'seller_id': sellerId,
    'customer_id': customerId,
    'customer_name': customerName,
    'customer_phone': customerPhone,
    'customer_address': customerAddress,
    'to_province_id': toProvinceId,
    'to_district_id': toDistrictId,
    'to_ward_code': toWardCode,
    'subtotal_amount': subtotalAmount.toString(),
    'shipping_fee': shippingFee.toString(),
    'total_amount': totalAmount.toString(),
    'payment_method': paymentMethod,
    'payment_status': paymentStatus,
    'shipping_provider': shippingProvider,
    'ghn_order_code': ghnOrderCode,
    'shipping_status': shippingStatus,
    'order_status': orderStatus,
    'from_name': fromName,
    'from_phone': fromPhone,
    'from_address': fromAddress,
    'from_district_id': fromDistrictId,
    'from_ward_code': fromWardCode,
    'from_province_id': fromProvinceId,
    'weight': weight,
    'length': length,
    'width': width,
    'height': height,
    'required_note': requiredNote,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'to_province_name': toProvinceName,
    'to_district_name': toDistrictName,
    'to_ward_name': toWardName,
    'from_province_name': fromProvinceName,
    'from_district_name': fromDistrictName,
    'from_ward_name': fromWardName,
    'product_image': productImage,
    'product_name': productName,
    'post_id': postId,
  };

  OrderResponse copyWith({
    int? id,
    String? orderCode,
    int? sellerId,
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    int? toProvinceId,
    int? toDistrictId,
    String? toWardCode,
    double? subtotalAmount,
    double? shippingFee,
    double? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? shippingProvider,
    String? ghnOrderCode,
    String? shippingStatus,
    String? orderStatus,
    String? fromName,
    String? fromPhone,
    String? fromAddress,
    int? fromDistrictId,
    String? fromWardCode,
    int? fromProvinceId,
    int? weight,
    int? length,
    int? width,
    int? height,
    String? requiredNote,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? toProvinceName,
    String? toDistrictName,
    String? toWardName,
    String? fromProvinceName,
    String? fromDistrictName,
    String? fromWardName,
    String? productImage,
    String? productName,
    int? postId,
  }) {
    return OrderResponse(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      sellerId: sellerId ?? this.sellerId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      toProvinceId: toProvinceId ?? this.toProvinceId,
      toDistrictId: toDistrictId ?? this.toDistrictId,
      toWardCode: toWardCode ?? this.toWardCode,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      shippingFee: shippingFee ?? this.shippingFee,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      shippingProvider: shippingProvider ?? this.shippingProvider,
      ghnOrderCode: ghnOrderCode ?? this.ghnOrderCode,
      shippingStatus: shippingStatus ?? this.shippingStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      fromName: fromName ?? this.fromName,
      fromPhone: fromPhone ?? this.fromPhone,
      fromAddress: fromAddress ?? this.fromAddress,
      fromDistrictId: fromDistrictId ?? this.fromDistrictId,
      fromWardCode: fromWardCode ?? this.fromWardCode,
      fromProvinceId: fromProvinceId ?? this.fromProvinceId,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      requiredNote: requiredNote ?? this.requiredNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      toProvinceName: toProvinceName ?? this.toProvinceName,
      toDistrictName: toDistrictName ?? this.toDistrictName,
      toWardName: toWardName ?? this.toWardName,
      fromProvinceName: fromProvinceName ?? this.fromProvinceName,
      fromDistrictName: fromDistrictName ?? this.fromDistrictName,
      fromWardName: fromWardName ?? this.fromWardName,
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      postId: postId ?? this.postId,
    );
  }

  @override
  String toString() {
    return 'OrderResponse(id: $id, orderCode: $orderCode, orderStatus: $orderStatus, totalAmount: $totalAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderResponse && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}