class PackageModel {
  int? id;
  String? name;
  int? durationDays;
  String? price;
  int? usageLimit;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? description;
  int? expiredAt;
  int? status;

  PackageModel(
      {this.id,
      this.name,
      this.durationDays,
      this.price,
      this.usageLimit,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.expiredAt,
      this.status});

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    durationDays = json['duration_days'];
    price = json['price'];
    usageLimit = json['usage_limit'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    expiredAt = json['expired_at'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['duration_days'] = this.durationDays;
    data['price'] = this.price;
    data['usage_limit'] = this.usageLimit;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    data['expired_at'] = this.expiredAt;
    data['status'] = this.status;
    return data;
  }
}