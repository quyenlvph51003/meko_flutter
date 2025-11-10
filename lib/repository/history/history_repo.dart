import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/paginated_result_common.dart';
import 'package:meko_project/models/response_common.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class HistoryRepo {
  final RestClient restClient;

  HistoryRepo({required this.restClient});

  Future<ResponseCommon<PaginatedResult<ListingItem>>> getListHistory({String? searchText, int page = 0, int size = 10}) async {
    try {
      final user = await SqliteHelper.getUserSql();
      if (user == null) {
        return ResponseCommon<PaginatedResult<ListingItem>>(
          datetime: '',
          errorCode: 500,
          message: 'User not found',
          data: null,
          content: const [],
          success: false,
        );
      }
      final response = await restClient.get(
        '${ApiPath.searchHistory}/${user.id}',
        queryParameters: {'page': page, 'size': size, 'searchText': searchText},
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
