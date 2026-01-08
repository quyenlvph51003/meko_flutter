import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:meko_project/models/body/ghn/ghn_province.dart';
import 'package:meko_project/models/body/ghn/ghn_district.dart';
import 'package:meko_project/models/body/ghn/ghn_ward.dart';

class GHNAddressRepo {
  static const String _baseUrl = 'https://online-gateway.ghn.vn/shiip/public-api/master-data';
  static const String _token = '83108489-e4c9-11f0-8437-06d420b5b0f1'; // GHN API Token

  final Dio _dio;

  GHNAddressRepo() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: 10000,
    receiveTimeout: 10000,
    headers: {
      'Content-Type': 'application/json',
      'Token': _token,
    },
  ));

  /// Lấy danh sách tỉnh/thành phố
  Future<List<GHNProvince>> getProvinces() async {
    try {
      final response = await _dio.get('/province');
      if (response.statusCode == 200 && response.data['code'] == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => GHNProvince.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting provinces: $e');
      return [];
    }
  }

  /// Lấy danh sách quận/huyện theo tỉnh
  Future<List<GHNDistrict>> getDistricts(int provinceId) async {
    try {
      final response = await _dio.post(
        '/district',
        data: {'province_id': provinceId},
      );
      if (response.statusCode == 200 && response.data['code'] == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => GHNDistrict.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting districts: $e');
      return [];
    }
  }

  /// Lấy danh sách phường/xã theo quận/huyện
  Future<List<GHNWard>> getWards(int districtId) async {
    try {
      final response = await _dio.post(
        '/ward',
        data: {'district_id': districtId},
      );
      if (response.statusCode == 200 && response.data['code'] == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => GHNWard.fromJson(e as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error getting wards: $e');
      return [];
    }
  }
}
