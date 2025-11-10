import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';

class ReportRepo {
  final RestClient restClient;

  ReportRepo({required this.restClient});

  Future<bool> getViolationList({required int postId, required int violationId, required int reportUserId, required String reason}) async {
    try {
      final response = await restClient.post(
        ApiPath.createReport,
        data: {'postId': postId, 'violationId': violationId, 'reportUserId': reportUserId, 'reason': reason},
      );
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
