import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class ReportRepo {
  final RestClient restClient;

  ReportRepo({required this.restClient});

  Future<bool> createReport({required int postId, required int violationId, required String reason}) async {
    try {
      final user = await SqliteHelper.getUserSql();
      if (user == null) {
        return false;
      }
      final data = {'postId': postId, 'violationId': violationId, 'reporterUserId': user.id, 'reason': reason};
      final response = await restClient.post(ApiPath.createReport, data: data);
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
