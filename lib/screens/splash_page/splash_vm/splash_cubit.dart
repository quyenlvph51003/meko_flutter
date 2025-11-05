import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/intro_page/intro_page.dart';
import 'package:meko_project/screens/splash_page/splash_vm/splash_state.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState(showContent: false));

  void init(BuildContext context) async {
    updateAnimation();
    Future.delayed(const Duration(milliseconds: 1500), () async {
      bool? checkFirstUseApp = await SharedPref.instance.getBool(AppConsts.keyIntro);
      bool checkLogin = await isCheckLogin();
      if (checkFirstUseApp == true) {
        if (!checkLogin) {
          await SqliteHelper.deleteAuthTokens();
          await SqliteHelper.deleteUserSql();
        }
        Navigator.pushReplacementNamed(context, AppRouterPaths.homePage);
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return IntroPage();
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 150),
          ),
        );
      }
    });
  }

  Future<bool> isCheckLogin() async {
    final authTokens = await SqliteHelper.getAuthTokens();

    if (authTokens == null) return false; // chưa có token => chưa đăng nhập

    final refreshTokenExpired = DateTime.tryParse(authTokens.refreshTokenExpired ?? '');
    if (refreshTokenExpired == null) return false; // dữ liệu lỗi => coi như hết hạn

    // So sánh thời gian hết hạn với thời gian hiện tại
    final isValid = refreshTokenExpired.isAfter(DateTime.now());
    return isValid;
  }

  void updateAnimation() {
    emit(state.copyWith(showContent: true));
  }
}
