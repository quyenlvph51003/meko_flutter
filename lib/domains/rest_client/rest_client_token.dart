import 'package:meko_project/models/body/auth/auth_token.dart';

class TokenStore {
  String? accessToken, refreshToken;
  DateTime? accessExp, refreshExp;

  void save(AuthTokens t) {
    accessToken = t.token;
    refreshToken = t.refreshToken;
    accessExp = t.tokenExpired;
    refreshExp = t.refreshTokenExpired;
  }

  void clear() {
    accessToken = refreshToken = null;
    accessExp = refreshExp = null;
  }
}

