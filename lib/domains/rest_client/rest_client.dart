import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/domains/rest_client/rest_client_token.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/global_data/data_local/sql_maneger.dart';
import 'package:meko_project/models/body/auth/auth_token.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class RestClient {
  static const String encodedContentType = 'application/x-www-form-urlencoded;charset=UTF-8';
  static const String jsonContentType = 'application/json';
  static const Duration defaultTimeout = Duration(seconds: 20);

  late final Dio dio;
  final tokenStore = TokenStore();
  bool isRefreshing = false;
  final List<Function(String)> refreshWaiters = [];

  RestClient(String baseUrl, {Duration timeout = defaultTimeout, String contentType = encodedContentType, Map<String, dynamic>? headers}) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: timeout.inMilliseconds,
      receiveTimeout: timeout.inMilliseconds,
      sendTimeout: timeout.inMilliseconds,
      contentType: contentType,
      responseType: ResponseType.json,
      headers: headers ?? {'Accept': 'application/json'},
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    );

    dio = Dio(options);
    setupInterceptors();
    setupHttpAdapter();
  }

  void setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest, onResponse: onResponse, onError: onError));

    if (kDebugMode) {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    }
  }

  void setupHttpAdapter() {
    if (kDebugMode) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
  }

  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authTokens = await SqliteHelper.getAuthTokens();
    String? accessToken = authTokens?.token;
    if (kDebugMode) {
      debugPrint('${options.method} ${options.uri}');
    }
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = '$accessToken';
    } else {
      tokenStore.clear();
    }
    handler.next(options);
  }

  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('${response.statusCode} ${response.requestOptions.uri} ');
    debugPrint(response.data.toString());
    handler.next(response);
  }

  Future<void> onError(DioError error, ErrorInterceptorHandler handler) async {
    logError(error);
    // Nếu có response trả về từ server
    if (error.response != null) {
      debugPrint('📡 STATUS CODE: ${error.response?.statusCode}');
      debugPrint('📦 RESPONSE DATA: ${error.response?.data}');
    } else {
      debugPrint('⚠️ No response received from server.');
    }
    final authTokenLocals = await SqliteHelper.getAuthTokens();
    final bool checkExpiredAccessToken = DateTime.tryParse(authTokenLocals?.tokenExpired ?? '')?.isBefore(DateTime.now()) ?? false;
    if (error.response?.statusCode == 401 && checkExpiredAccessToken) {
      try {
        final resultToken = await refreshAccessToken();
        final AuthTokens authTokens = AuthTokens.fromJson(resultToken);
        if (authTokens != null) {
          final AuthTokens authTokensLocal = AuthTokens(
            token: authTokens.token,
            refreshToken: authTokens.refreshToken,
            tokenExpired: authTokens.tokenExpired,
            refreshTokenExpired: authTokenLocals?.refreshTokenExpired,
          );
          await SQLiteManager.instance().put(AppConsts.keyAuthTokens, authTokensLocal.toJson());
          final requestOptions = error.requestOptions;
          requestOptions.headers['Authorization'] = '${authTokens.token}';
          final clonedResponse = await dio.fetch(requestOptions);
          return handler.resolve(clonedResponse);
        } else {
          tokenStore.clear();
        }
      } catch (e) {
        print(e);
        tokenStore.clear();
      }
    }
    handler.next(error);
  }

  void logError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        debugPrint('⛔ Connection timeout');
        break;
      case DioErrorType.receiveTimeout:
        debugPrint('⛔ Receive timeout');
        break;
      case DioErrorType.sendTimeout:
        debugPrint('⛔ Send timeout');
        break;
      case DioErrorType.response:
        final statusCode = error.response?.statusCode;
        debugPrint('⛔ HTTP Error: $statusCode');
        break;
      case DioErrorType.cancel:
        debugPrint('⚠️ Request cancelled');
        break;
      case DioErrorType.other:
        debugPrint('❌ Network error: ${error.message}');
        break;
    }
  }

  Future<dynamic> refreshAccessToken() async {
    if (isRefreshing) {
      final completer = Completer<String?>();
      refreshWaiters.add((token) => completer.complete(token));
      return completer.future;
    }

    isRefreshing = true;
    final authTokens = await SqliteHelper.getAuthTokens();
    final user = await SqliteHelper.getUserSql();
    try {
      final refreshToken = authTokens?.refreshToken;
      if (refreshToken == null) return null;

      final response = await dio.post(
        'auth/refresh-token',
        data: {'refreshToken': refreshToken, "email": user?.email},
        options: Options(contentType: 'application/json'),
      );

      final newAccessToken = response.data['accessToken'] as String?;
      final newRefreshToken = response.data['refreshToken'] as String? ?? refreshToken;
      SharedPref.instance.setString(AppConsts.keyToken, newAccessToken ?? '');
      SharedPref.instance.setString(AppConsts.keyRefreshToken, newRefreshToken);
      if (newAccessToken != null) {
        tokenStore.save(AuthTokens(token: newAccessToken, refreshToken: newRefreshToken));

        for (final waiter in refreshWaiters) {
          waiter(newAccessToken);
        }
        refreshWaiters.clear();
      }
      return response.data['data'];
    } catch (e) {
      print(e);
      return null;
    } finally {
      isRefreshing = false;
    }
  }
}
