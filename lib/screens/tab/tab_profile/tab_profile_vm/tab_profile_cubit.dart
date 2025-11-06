import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/tab/homes_page/home_vm/home_cubit.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_state.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_dialog/app_dialog.dart';

class TabProfileCubit extends Cubit<TabProfileState> {
  TabProfileCubit({required this.authRepository}) : super(TabProfileState.initial());
  final AuthRepository authRepository;

  Future<void> getUserProfile() async {
    final userProfile = await SqliteHelper.getUserSql();
    if (userProfile != null) {
      emit(state.copyWith(user: userProfile));
    }
  }

  Future<void> logoutAccount(BuildContext context) async {
    try {
      await AppDialog.confirm(
        title: 'Thông báo',
        message: 'bạn có muốn đăng xuất tài khoản?',
        onOk: () async {
          await authRepository.logout();
          SharedPref.instance.setBool(AppConsts.keyLoginSuccess, false);
          getIt<HomeCubit>().isCheckLogin();
          getIt<HomeCubit>().refreshHome();
          Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(AppRouterPaths.login, (route) => false, arguments: {'showBack': false});
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
