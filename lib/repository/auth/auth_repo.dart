import 'package:dio/dio.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/models/body/auth/auth_token.dart';
import 'package:meko_project/models/response_common.dart';

class AuthRepository {
  final RestClient restClient;
  final SharedPref sharedPref;

  AuthRepository({required this.restClient, required this.sharedPref});

  Future<ResponseCommon<void>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    final res = await restClient.post(
      ApiPath.authRegister,
      data: {'email': email, 'password': password, 'username': username},
    );
    return ResponseCommon<void>.fromJson(res.data, (_) => null);
  }

  Future<Response?> login({required String email, required String password}) async {
    try {
      return await restClient.post(ApiPath.authLogin, data: {'email': email, 'password': password});
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Response?> requestOtp({required String email}) async {
    try {
      return await restClient.post(ApiPath.authRequestOtp, data: {'email': email});
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseCommon<void>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final res = await restClient.post(
      ApiPath.authVerifyOtp,
      data: {'email': email, 'otp': otp},
    );
    return ResponseCommon<void>.fromJson(res.data, (_) => null);
  }

  Future<bool> loginAndSaveToken({required String email, required String password}) async {
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
      return await restClient.post(ApiPath.authRefresh, data: {'refreshToken': refreshToken});
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> logout() async {
    await sharedPref.setBool(AppConsts.keyLoginSuccess, false);
    await restClient.tokenStore.clear();
  }

  bool get isAuthenticated => restClient.tokenStore.accessToken != null;

  String? get accessToken => restClient.tokenStore.accessToken;

  String? get currentRefreshToken => restClient.tokenStore.refreshToken;
}
