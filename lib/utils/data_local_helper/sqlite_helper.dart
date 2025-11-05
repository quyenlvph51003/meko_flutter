import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/sql_maneger.dart';
import 'package:meko_project/models/body/auth/auth_token.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/routers/app_router_paths.dart';

class SqliteHelper {
  //users
  static Future<UserModel?> getUserSql() async {
    final userJson = await SQLiteManager.instance().get<Map<String, dynamic>>(
      AppConsts.userSql,
    );
    if (userJson != null) {
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  static Future<void> deleteUserSql() async {
    await SQLiteManager.instance().delete(AppConsts.userSql);
  }

  //auth
  static Future<void> deleteAuthTokens() async {
    await SQLiteManager.instance().delete(AppConsts.keyAuthTokens);
  }

  static Future<AuthTokens?> getAuthTokens() async {
    final authTokensJson = await SQLiteManager.instance()
        .get<Map<String, dynamic>>(AppConsts.keyAuthTokens);
    if (authTokensJson != null) {
      return AuthTokens.fromJson(authTokensJson);
    }
    return null;
  }

  //check hiẻn thị login nếu chưa đăng nhập và muốn sử dụng chức nằng cần đăng nhập
  static Future<bool> isCheckShowAuth(BuildContext context) async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      return true;
    }
    return false;
  }
}
