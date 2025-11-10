import 'dart:convert';

import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/paginated_result_common.dart';
import 'package:meko_project/models/response_common.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class PostRepo {
  final RestClient restClient;
  PostRepo({required this.restClient});

  Future<ResponseCommon<PaginatedResult<ListingItem>>> getPosts({int page = 0, int size = 10, PostSearchRequest? postSearchRequest}) async {
    try {
      final response = await restClient.post(
        ApiPath.searchPost,
        queryParameters: {'page': page, 'size': size},
        data: postSearchRequest?.toJson() ?? {},
      );
      if (response.data == null) {
        return ResponseCommon<PaginatedResult<ListingItem>>(
          datetime: '',
          errorCode: 500,
          message: 'No data',
          data: null,
          content: const [],
          success: false,
        );
      }
      return ResponseCommon<PaginatedResult<ListingItem>>.fromJson(
        response.data,
        (obj) => PaginatedResult<ListingItem>.fromJson((obj as Map<String, dynamic>), (m) => ListingItem.fromJson(m)),
      );
    } catch (e) {
      return ResponseCommon<PaginatedResult<ListingItem>>(
        datetime: '',
        errorCode: 500,
        message: e.toString(),
        data: null,
        content: const [],
        success: false,
      );
    }
  }

  Future<ResponseCommon<ListingItem>> getPostDetail({required int id}) async {
    try {
      final user = await SqliteHelper.getUserSql();
      String query = '';
      if (user != null) {
        query = '?userId=${user.id}';
      }
      final response = await restClient.get('${ApiPath.postDetail}/$id$query');
      return ResponseCommon<ListingItem>.fromJson(response.data, (obj) => ListingItem.fromJson(obj as Map<String, dynamic>));
    } catch (e) {
      return ResponseCommon<ListingItem>(datetime: '', errorCode: 500, message: e.toString(), data: null, content: const [], success: false);
    }
  }

  Future<ListingItem> getPostDetailItem(int id) async {
    final res = await getPostDetail(id: id);
    if (res.data != null) {
      return res.data as ListingItem;
    }
    return ListingItem.fromJson(res.toJson()['data'] as Map<String, dynamic>? ?? <String, dynamic>{});
  }
}

class PostSearchRequest {
  final PostStatus? status;
  final int? userId;
  final String? wardCode;
  final String? provinceCode;
  final String? searchText;
  final List<int>? categoryIds;
  final int? userPosterId;

  PostSearchRequest({this.status, this.userId, this.wardCode, this.provinceCode, this.searchText, this.categoryIds, this.userPosterId});

  Map<String, dynamic> toJson() {
    return {
      'status': postStatusMapStr[status] ?? 'PENDING',
      'userId': userId,
      'wardCode': wardCode,
      'provinceCode': provinceCode,
      'searchText': searchText,
      'categoryIds': (categoryIds?.length == 1) ? [categoryIds?[0], categoryIds?[0]] : categoryIds,
      'userPosterId': userPosterId,
    };
  }
}
