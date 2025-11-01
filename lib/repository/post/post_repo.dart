import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/paginated_result_common.dart';
import 'package:meko_project/models/response_common.dart';

class PostRepo {
  final RestClient restClient;
  PostRepo({required this.restClient});

  Future<ResponseCommon<PaginatedResult<ListingItem>>> getPosts({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await restClient.post(
        ApiPath.searchPost,
        queryParameters: {'page': page, 'size': size},
      );
      return ResponseCommon<PaginatedResult<ListingItem>>.fromJson(
        response.data,
            (obj) => PaginatedResult<ListingItem>.fromJson(
          (obj as Map<String, dynamic>),
              (m) => ListingItem.fromJson(m),
        ),
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
