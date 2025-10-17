class AuthTokens {
  AuthTokens({
    this.token,
    this.refreshToken,
    this.tokenExpired,
    this.refreshTokenExpired,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    token: json['token'] as String?,
    refreshToken: json['refreshToken'] as String?,
    tokenExpired: json['tokenExpired'] != null
        ? DateTime.parse(json['tokenExpired'] as String)
        : null,
    refreshTokenExpired: json['refreshTokenExpired'] != null
        ? DateTime.parse(json['refreshTokenExpired'] as String)
        : null,
  );

  String? token;
  String? refreshToken;
  DateTime? tokenExpired;
  DateTime? refreshTokenExpired;

  Map<String, dynamic> toJson() => {
    'token': token,
    'refreshToken': refreshToken,
    'tokenExpired': tokenExpired?.toIso8601String(),
    'refreshTokenExpired': refreshTokenExpired?.toIso8601String(),
  };
}
