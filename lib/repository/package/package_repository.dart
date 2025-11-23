import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/package/package_model.dart';
import 'package:meko_project/models/response_common.dart';

class PackageRepository {
  final RestClient restClient;

  PackageRepository({required this.restClient});

  Future<ResponseCommon<List<PackageModel>>> getPaymens() async {
    try {
      final response = await restClient.get('${ApiPath.getPackages}',queryParameters: {'isActive':1});
      return ResponseCommon<List<PackageModel>>.fromJson(
        response.data,
        (obj) => (obj as List).map((e) => PackageModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return ResponseCommon<List<PackageModel>>(datetime: '', errorCode: 500, message: e.toString(), data: null, content: const [], success: false);
    }
  }


}