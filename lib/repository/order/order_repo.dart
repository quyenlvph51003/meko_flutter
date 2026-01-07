import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/order/order_list_response.dart';
import 'package:meko_project/models/body/order/order_request.dart';
import 'package:meko_project/models/body/order/order_response.dart';
import 'package:meko_project/models/response_common.dart';

class OrderRepository {
  final RestClient restClient;

  OrderRepository({required this.restClient});

  Future<ResponseCommon<OrderResponse>> createOrder(OrderRequest request) async {
    try {
      final response = await restClient.post(
        ApiPath.orderCreate,
        data: request.toJson(),
      );
      return ResponseCommon<OrderResponse>.fromJson(
        response.data,
            (json) => OrderResponse.fromJson(json),
      );
    } catch (e) {
      return ResponseCommon<OrderResponse>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: [],
        success: false,
      );
    }
  }
  Future<ResponseCommon<OrderResponse>> getOrderByCode(String orderCode) async {
    try {
      print('=== Calling API: ${ApiPath.orderByCode}/$orderCode ===');
      final response = await restClient.get('${ApiPath.orderByCode}/$orderCode');
      print('=== API Response: ${response.data} ===');

      final result = ResponseCommon<OrderResponse>.fromJson(
        response.data,
            (json) => OrderResponse.fromJson(json),
      );
      print('=== Parsed success: ${result.success}, data: ${result.data} ===');
      return result;
    } catch (e) {
      print('=== API Error: $e ===');
      return ResponseCommon<OrderResponse>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: [],
        success: false,
      );
    }
  }

  Future<ResponseCommon<OrderListResponse>> getOrders({
    int? sellerId,
    int? customerId,
    String? orderStatus,
    String? shippingStatus,
    String? paymentStatus,
    int page = 0,
    int limit = 20,
    String orderBy = 'created_at',
    String sort = 'DESC',
  }) async {
    try {
      // Build query params
      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
        'orderBy': orderBy,
        'sort': sort,
      };

      if (sellerId != null) queryParams['seller_id'] = sellerId;
      if (customerId != null) queryParams['customer_id'] = customerId;
      if (orderStatus != null) queryParams['order_status'] = orderStatus;
      if (shippingStatus != null) queryParams['shipping_status'] = shippingStatus;
      if (paymentStatus != null) queryParams['payment_status'] = paymentStatus;

      // Build URL with query string
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final url = '${ApiPath.orderList}?$queryString';
      print('=== Calling API: $url ===');

      final response = await restClient.get(url);
      print('=== API Response: ${response.data} ===');

      // Parse response
      final Map<String, dynamic> responseData = response.data;

      if (responseData['success'] == true) {
        return ResponseCommon<OrderListResponse>(
          datetime: responseData['datetime'] ?? '',
          errorCode: responseData['error_code'] ?? 0,
          message: responseData['message'] ?? '',
          data: OrderListResponse.fromJson(responseData),
          content: [],
          success: true,
        );
      } else {
        return ResponseCommon<OrderListResponse>(
          datetime: responseData['datetime'] ?? '',
          errorCode: responseData['error_code'] ?? 500,
          message: responseData['message'] ?? 'Lấy danh sách đơn hàng thất bại',
          data: null,
          content: [],
          success: false,
        );
      }
    } catch (e) {
      print('=== API Error: $e ===');
      return ResponseCommon<OrderListResponse>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: [],
        success: false,
      );
    }
  }

  /// Lấy danh sách đơn hàng đang bán (cho seller)
  Future<ResponseCommon<OrderListResponse>> getSellingOrders({
    required int sellerId,
    String? orderStatus,
    int page = 0,
    int limit = 20,
  }) {
    return getOrders(
      sellerId: sellerId,
      orderStatus: orderStatus,
      page: page,
      limit: limit,
    );
  }

  /// Lấy danh sách đơn hàng đã mua (cho buyer)
  Future<ResponseCommon<OrderListResponse>> getBuyingOrders({
    required int customerId,
    String? orderStatus,
    int page = 0,
    int limit = 20,
  }) {
    return getOrders(
      customerId: customerId,
      orderStatus: orderStatus,
      page: page,
      limit: limit,
    );
  }

  /// Xác nhận đơn hàng - Tạo vận đơn GHN (cho seller)
  Future<ResponseCommon<OrderResponse>> confirmOrderGHN(int orderId) async {
    try {
      final url = '${ApiPath.orderGhnCreate}/$orderId';
      print('=== Calling API: $url ===');

      final response = await restClient.post(url);
      print('=== API Response: ${response.data} ===');

      return ResponseCommon<OrderResponse>.fromJson(
        response.data,
        (json) => OrderResponse.fromJson(json),
      );
    } catch (e) {
      print('=== API Error: $e ===');
      return ResponseCommon<OrderResponse>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: [],
        success: false,
      );
    }
  }
}