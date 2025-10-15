// repository/auth_repository/auth_repo.dart
import 'package:dio/dio.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/auth/auth_token.dart';

class AuthRepository {
  final RestClient restClient;

  // Constructor nhận restClient từ dependency injection
  AuthRepository({required this.restClient});

  Future<Response?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      return await restClient.post(
        ApiPath.authRegister,
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> login({
    required String email,
    required String password,
  }) async {
    try {
      return await restClient.post(
        ApiPath.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> loginAndSaveToken({
    required String email,
    required String password,
  }) async {
    try {
      final response = await login(email: email, password: password);
      if (response != null && response.statusCode == 200) {
        final authTokens = AuthTokens.fromJson(response.data);
        restClient.tokenStore.save(authTokens);
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Response?> refreshToken(String refreshToken) async {
    try {
      return await restClient.post(
        ApiPath.authRefresh,
        data: {'refreshToken': refreshToken},
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  void logout() {
    restClient.tokenStore.clear();
  }

  bool get isAuthenticated => restClient.tokenStore.accessToken != null;

  String? get accessToken => restClient.tokenStore.accessToken;

  String? get currentRefreshToken => restClient.tokenStore.refreshToken;
}