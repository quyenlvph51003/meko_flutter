import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository})
      : super(LoginState(
    usernameCtrl: TextEditingController(),
    passwordCtrl: TextEditingController(),
  ));

  Future<void> login() async {
    final email = state.usernameCtrl.text.trim();
    final password = state.passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      emit(state.copyWith(errorMessage: 'Vui lòng nhập đầy đủ thông tin'));
      return;
    }
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final success = await authRepository.loginAndSaveToken(
        email: email,
        password: password,
      );

      if (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        SharedPref.instance.setBool(AppConsts.keyLoginSuccess, true);
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Email hoặc mật khẩu không đúng',
        ));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Đã có lỗi xảy ra. Vui lòng thử lại',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  @override
  Future<void> close() {
    state.usernameCtrl.dispose();
    state.passwordCtrl.dispose();
    return super.close();
  }
}