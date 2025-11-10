import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/review/review_model.dart';
import 'package:meko_project/models/body/violation/violation_model.dart';
import 'package:meko_project/models/response_common.dart';

class ViolationRepo {
  final RestClient restClient;

  ViolationRepo({required this.restClient});

  Future<ResponseCommon<List<ViolationModel>>> getViolationList() async {
    try {
      final response = await restClient.get(ApiPath.getViolationList);
      if (response.data == null) {
        return ResponseCommon<List<ViolationModel>>(datetime: '', errorCode: 500, message: 'No data', data: null, content: const [], success: false);
      }
      return ResponseCommon<List<ViolationModel>>.fromJson(
        response.data,
        (obj) => (obj is List)
            ? obj.where((e) => e is Map).map((e) => ViolationModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
            : <ViolationModel>[],
      );
    } catch (error) {
      print(error);
      return ResponseCommon<List<ViolationModel>>(datetime: '', errorCode: 500, message: 'No data', data: null, content: const [], success: false);
    }
  }
}
