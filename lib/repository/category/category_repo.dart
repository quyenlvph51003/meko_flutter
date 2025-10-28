import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/response_common.dart';

class CategoryRepository {
  final RestClient restClient;

  CategoryRepository({required this.restClient});

  Future<ResponseCommon<Category>> getAllCategory() async {
    try {
      final response = await restClient.get(ApiPath.categoryList);
      return ResponseCommon<Category>.fromJsonList(
        response.data,
            (json) => Category.fromJson(json),
      );
    } catch (e) {
      return ResponseCommon<Category>(
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