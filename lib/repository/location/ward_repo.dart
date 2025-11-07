import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/models/response_common.dart';

class WardRepo {
  final RestClient restClient;
  WardRepo({required this.restClient});

  Future<ResponseCommon<List<WardModel>>> getWards({required String provinceCodeId}) async {
    try {
      final response = await restClient.get('${ApiPath.getWards}?provinceCode=$provinceCodeId');
      return ResponseCommon<List<WardModel>>.fromJson(
        response.data,
        (obj) => (obj as List).map((e) => WardModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return ResponseCommon<List<WardModel>>(datetime: '', errorCode: 500, message: e.toString(), data: null, content: const [], success: false);
    }
  }
}
