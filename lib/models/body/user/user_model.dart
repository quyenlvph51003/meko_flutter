class UserModel {
  int? id;
  String? username;
  String? email;
  String? password;
  int? role;
  String? createdAt;
  String? updatedAt;
  String? tokenExpired;
  String? refreshToken;
  String? refreshExpired;
  String? otpCode;
  String? otpExpired;
  String? addressName;
  String? avatar;
  int? isActive;
  double? walletBalance;
  String? pinWallet;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.tokenExpired,
    this.refreshToken,
    this.refreshExpired,
    this.otpCode,
    this.otpExpired,
    this.addressName,
    this.avatar,
    this.isActive,
    this.walletBalance,
    this.pinWallet,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tokenExpired = json['token_expired'];
    refreshToken = json['refresh_token'];
    refreshExpired = json['refresh_expired'];
    otpCode = json['otp_code'];
    otpExpired = json['otp_expired'];
    addressName = json['address_name'];
    avatar = json['avatar'];
    isActive = json['is_active'];
    walletBalance = json['wallet_balance'];
    pinWallet = json['pin_wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['token_expired'] = this.tokenExpired;
    data['refresh_token'] = this.refreshToken;
    data['refresh_expired'] = this.refreshExpired;
    data['otp_code'] = this.otpCode;
    data['otp_expired'] = this.otpExpired;
    data['address_name'] = this.addressName;
    data['avatar'] = this.avatar;
    data['is_active'] = this.isActive;
    data['wallet_balance'] = this.walletBalance;
    data['pin_wallet'] = this.pinWallet;
    return data;
  }
}
