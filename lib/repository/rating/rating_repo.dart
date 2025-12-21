import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';

class RatingRepo {
  final RestClient restClient;
  RatingRepo({required this.restClient});

  Future<bool> ratePost({required int postId, required int rating}) async {
    try {
      final response = await restClient.post(ApiPath.ratingRate, data: {'postId': postId, 'rating': rating});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
