import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/response_common.dart';

class ProvinceRepo {
  final RestClient restClient;
  ProvinceRepo({required this.restClient});

  Future<ResponseCommon<List<ProvinceModel>>> getProvinces() async {
    try {
      final response = await restClient.get(ApiPath.getAllProvince);
      return ResponseCommon<List<ProvinceModel>>.fromJson(
        response.data,
        (obj) => (obj as List).map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return ResponseCommon<List<ProvinceModel>>(datetime: '', errorCode: 500, message: e.toString(), data: null, content: const [], success: false);
    }
  }
}
