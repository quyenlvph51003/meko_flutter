import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/domains/api_path/api_path.dart';
import 'package:meko_project/domains/rest_client/rest_client.dart';
import 'package:meko_project/domains/rest_client/rest_client_extension.dart';
import 'package:meko_project/global_data/data_local/hive_db.dart';
import 'package:meko_project/global_data/data_local/sql_maneger.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/models/response_common.dart';

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
}
