import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RestClient {
  static const String encodedContentType = 'application/x-www-form-urlencoded;charset=UTF-8';
  static const Duration defaultTimeout = Duration(seconds: 20);

  late Dio dio;

  RestClient(
    String baseUrl, {
    Duration timeout = defaultTimeout,
  }) {
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: defaultTimeout.inMilliseconds,
      receiveTimeout: defaultTimeout.inMilliseconds,
      contentType: encodedContentType,
      responseType: ResponseType.json,
    );

    dio = Dio(options);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ Request: ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response: ${response.statusCode} ${response.data}");
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          switch (e.type) {
            case DioErrorType.connectTimeout:
              print("⛔ Kết nối quá thời gian");
              break;

            case DioErrorType.receiveTimeout:
              print("⛔ Nhận dữ liệu quá thời gian");
              break;

            case DioErrorType.response:
              final statusCode = e.response?.statusCode;
              switch (statusCode) {
                case 401:
                  print("⛔ Không có quyền (401) – Token hết hạn?");
                  break;
                case 403:
                  print("⛔ Bị từ chối quyền truy cập (403)");
                  break;
                case 404:
                  print("⛔ API không tìm thấy (404)");
                  break;
                case 500:
                  print("⛔ Lỗi server nội bộ (500)");
                  break;
                default:
                  print("⛔ Lỗi HTTP khác: $statusCode");
              }
              break;

            case DioErrorType.cancel:
              print("⚠️ Request bị hủy");
              break;

            case DioErrorType.sendTimeout:
              print("⛔ Gửi request quá lâu");
              break;

            case DioErrorType.other:
              print("❌ Lỗi không xác định hoặc mất mạng: ${e.message}");
              break;
          }

          return handler.next(e);
        },
      ),
    );

    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: !kReleaseMode));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }
}
