import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/models/body/review/review_model.dart';
import 'package:meko_project/models/response_common.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class ReviewRepo {
  final RestClient restClient;

  ReviewRepo({required this.restClient});

  Future<ResponseCommon<List<ReviewModel>>> getReviewList({required int postId}) async {
    try {
      final response = await restClient.get('${ApiPath.reviewList}/$postId');
      if (response.data == null) {
        return ResponseCommon<List<ReviewModel>>(datetime: '', errorCode: 500, message: 'No data', data: null, content: const [], success: false);
      }
      return ResponseCommon<List<ReviewModel>>.fromJson(
        response.data,
        (obj) => (obj is List)
            ? obj.where((e) => e is Map).map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
            : <ReviewModel>[],
      );
    } catch (error) {
      print(error);
      return ResponseCommon<List<ReviewModel>>(datetime: '', errorCode: 500, message: 'No data', data: null, content: const [], success: false);
    }
  }

  //create
  Future<bool> createReview({required int postId, required String content, int? parentId}) async {
    try {
      final user = await SqliteHelper.getUserSql();
      if (user == null) {
        return false;
      }
      final data = {'postId': postId, 'comment': content, 'userId': user.id};

      if (parentId != null) {
        data['parentId'] = parentId;
      }
      final response = await restClient.post(ApiPath.createReview, data: data);
      print(response.data);
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  //update
  Future<bool> upateReview({required int reviewId, required String content}) async {
    try {
      ///reviewId hoặc replyId
      final user = await SqliteHelper.getUserSql();
      if (user == null) {
        return false;
      }
      final response = await restClient.put('${ApiPath.updateReview}/$reviewId', data: {"comment": content});
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  //delete
  Future<bool> deleteReview({required int reviewId}) async {
    try {
      //review hoặc reply nhé
      final response = await restClient.delete('${ApiPath.deleteReview}/$reviewId');
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
