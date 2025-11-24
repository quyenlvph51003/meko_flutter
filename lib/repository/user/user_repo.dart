import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/global_data/data_local/hive_db.dart';
import 'package:meko_project/global_data/data_local/sql_maneger.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/models/response_common.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class UserRepo {
  final RestClient restClient;
  final SQLiteManager sqLiteManager;

  UserRepo({required this.restClient, required this.sqLiteManager});

  Future<dynamic> getUserProfile() async {
    final response = await restClient.get(ApiPath.getProfile);
    if (response.statusCode == 200 && response.data != null) {
      final result = ResponseCommon<dynamic>.fromJson(response.data, (obj) => UserModel.fromJson(obj as Map<String, dynamic>));
      await sqLiteManager.put(AppConsts.userSql, result.data!.toJson());
      return result;
    }
    return null;
  }

  Future<bool> createPinWallet({required String pin, required int userId}) async {
    try {
      final response = await restClient.post(ApiPath.createWallet, data: {'pinWallet': pin, 'userId': userId});
      if (response.statusCode == 200 && response.data != null) {
        final result = ResponseCommon<UserModel>.fromJson(response.data, (obj) => UserModel.fromJson(obj as Map<String, dynamic>));
        await sqLiteManager.put(AppConsts.userSql, result.data!.toJson());
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<UserModel?> updateAvatar(String filePath) async {
    try {
      final userLocal = await SqliteHelper.getUserSql();
      final response = await restClient.uploadFilePut('${ApiPath.updateAvatar}/${userLocal?.id}', filePath, fileKey: 'avatar');
      if (response.statusCode == 200 && response.data != null) {
        final result = ResponseCommon<UserModel>.fromJson(response.data, (obj) => UserModel.fromJson(obj as Map<String, dynamic>));
        final user = result.data;
        if (user != null) {
          await sqLiteManager.put(AppConsts.userSql, user.toJson());
        }
        return user;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserModel?> updateProfile({String? username, String? email, String? addressName}) async {
    try {
      final userLocal = await SqliteHelper.getUserSql();
      if (userLocal == null) return null;
      final payload = <String, dynamic>{};
      payload['userId'] = userLocal.id;
      if (username != null) payload['username'] = username;
      if (email != null) payload['email'] = email;
      if (addressName != null) payload['address'] = addressName;
      final response = await restClient.put(ApiPath.updateProfile, data: payload);
      if (response.statusCode == 200 && response.data != null) {
        final result = ResponseCommon<UserModel>.fromJson(response.data, (obj) => UserModel.fromJson(obj as Map<String, dynamic>));
        final updated = result.data;
        if (updated != null) {
          await sqLiteManager.put(AppConsts.userSql, updated.toJson());
        }
        return updated;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
