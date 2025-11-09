import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/paginated_result_common.dart';
import 'package:meko_project/models/response_common.dart';

class FavoriteRepo {
  final RestClient restClient;
  FavoriteRepo({required this.restClient});

  Future<bool> createFavorite({required int postId, required int userId}) async {
    try {
      final response = await restClient.post(ApiPath.createFavorite, data: {'postId': postId, 'userId': userId});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFavorite({required int postId, required int userId}) async {
    try {
      final response = await restClient.delete(ApiPath.deleteFavorite, queryParameters: {'postId': postId, 'userId': userId});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<ResponseCommon<PaginatedResult<ListingItem>>> getFavoriteList({required int userId, String? searchText, int page = 0, int size = 10}) async {
    try {
      final response = await restClient.post(
        ApiPath.searchFavorite,
        data: {'userId': userId, 'searchText': searchText ?? ''},
        queryParameters: {'page': page, 'size': size},
      );
      return ResponseCommon<PaginatedResult<ListingItem>>.fromJson(
        response.data,
        (json) => PaginatedResult<ListingItem>.fromJson((json as Map<String, dynamic>), (m) => ListingItem.fromJson(m)),
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
}
