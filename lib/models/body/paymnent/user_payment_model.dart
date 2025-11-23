
class UserPaymentModel {
  int? id;
  int? userId;
  int? packageId;
  String? amount;
  String? paymentStatus;
  String? transactionCode;
  int? usageRemaining;
  String? expiredAt;
  String? createdAt;
  String? updatedAt;
  int? durationUsed;
  String? packageName;
  int? usageLimit;

  UserPaymentModel(
      {this.id,
      this.userId,
      this.packageId,
      this.amount,
      this.paymentStatus,
      this.transactionCode,
      this.usageRemaining,
      this.expiredAt,
      this.createdAt,
      this.updatedAt,
      this.durationUsed,
      this.packageName,
      this.usageLimit});

  UserPaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    packageId = json['package_id'];
    amount = json['amount'];
    paymentStatus = json['payment_status'];
    transactionCode = json['transaction_code'];
    usageRemaining = json['usage_remaining'];
    expiredAt = json['expired_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    durationUsed = json['duration_used'];
    packageName = json['package_name'];
    usageLimit = json['usage_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['package_id'] = this.packageId;
    data['amount'] = this.amount;
    data['payment_status'] = this.paymentStatus;
    data['transaction_code'] = this.transactionCode;
    data['usage_remaining'] = this.usageRemaining;
    data['expired_at'] = this.expiredAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['duration_used'] = this.durationUsed;
    data['package_name'] = this.packageName;
    data['usage_limit'] = this.usageLimit;
    return data;
  }
}