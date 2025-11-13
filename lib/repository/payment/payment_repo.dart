import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/response_common.dart';

class PaymentRepo {
  final RestClient restClient;

  PaymentRepo({required this.restClient});

  Future<dynamic> createPayment({required double amount, required int userId}) async {
    try {
      final response = await restClient.post(ApiPath.payment, data: {'amount': amount, 'userId': userId});
      if (response.statusCode == 200 && response.data != null) {
        final result = response.data['data'];
        return result;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
