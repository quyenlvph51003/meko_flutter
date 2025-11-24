import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/tab/homes_page/home_vm/home_cubit.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_state.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_dialog/app_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meko_project/repository/user/user_repo.dart';

class TabProfileCubit extends Cubit<TabProfileState> {
  TabProfileCubit({required this.authRepository}) : super(TabProfileState.initial());
  final AuthRepository authRepository;

  Future<void> getUserProfile() async {
    final userProfile = await SqliteHelper.getUserSql();
    if (userProfile != null) {
      emit(state.copyWith(user: userProfile));
    }
  }

  // change page
  Future<void> changePage(BuildContext context, String passwordOld, String passwordNew) async {
    final result = await authRepository.changePass(passwordOld: passwordOld, passwordNew: passwordNew);
    if (result) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Thay đổi mật khẩu thành công',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.cMain,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  // change pin
  Future<void> changePin(BuildContext context, String pinWalletOld, String pinWalletNew) async {
    final result = await authRepository.changePinCodeWalltet(pinWalletOld: pinWalletOld, pinWalletNew: pinWalletNew);
    if (result) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Thay đổi mã pin thành công',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.cMain,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

  Future<void> pickAndUpdateAvatar(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked == null) return;
      final userRepo = getIt<UserRepo>();
      final updated = await userRepo.updateAvatar(picked.path);
      if (updated != null) {
        emit(state.copyWith(user: updated));
        Fluttertoast.showToast(
          msg: 'Cập nhật ảnh đại diện thành công',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColor.cMain,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Cập nhật ảnh đại diện thất bại',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
