class AuthTokens {
  String? token;
  String? refreshToken;
  String? tokenExpired;
  String? refreshTokenExpired;
  int? role;

  AuthTokens({
    this.token,
    this.refreshToken,
    this.tokenExpired,
    this.refreshTokenExpired,
    this.role,
  });

  AuthTokens.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    refreshToken = json['refreshToken'];
    tokenExpired = json['tokenExpired'];
    refreshTokenExpired = json['refreshTokenExpired'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    data['tokenExpired'] = this.tokenExpired;
    data['refreshTokenExpired'] = this.refreshTokenExpired;
    data['role'] = this.role;
    return data;
  }
}
