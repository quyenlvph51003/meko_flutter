import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';

class FavoriteRepo {
  final RestClient restClient;
  FavoriteRepo({required this.restClient});

  Future<bool> createFavorite({required int postId, required int userId}) async {
    try {
      final response = await restClient.post(ApiPath.createFavorite, data: {'postId': postId, 'userId': userId});
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> deleteFavorite({required int postId, required int userId}) async {
  //   try {
  //     final response = await restClient.delete(ApiPath.deleteFavorite(postId), data: {'postId': postId, 'userId': userId});
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
