import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';



class LoginCubit extends Cubit<LoginState> {
  LoginCubit()
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

      await Future.delayed(const Duration(seconds: 2));

      if (email != null || password != null) {
        emit(state.copyWith(isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Email hoặc mật khẩu không đúng',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Đã có lỗi xảy ra: ${e.toString()}',
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