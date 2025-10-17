import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_vm/sign_up_state.dart';
import 'package:meko_project/widget/app_validators/app_validators.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository authRepository;

  SignUpCubit({required this.authRepository}) : super(SignUpState.initial());

  void toggleTerms(bool v) {
    emit(state.copyWith(acceptedTerms: v));
  }

  Future<void> register() async {
    final userName = state.userName.text.trim();
    final email = state.emailCtrl.text.trim();
    final pass = state.passwordCtrl.text;

    if (userName.isEmpty) {
      emit(state.copyWith(message: 'Vui lòng nhập họ tên'));
      return;
    }
    AppValidators.email(email);
    AppValidators.password(pass);

    emit(state.copyWith(isLoading: true, message: null, isSuccess: false));

    try {
      final res = await authRepository.register(
        email: email,
        password: pass,
        username: userName,
      );

      if (res.success) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: res.message.isNotEmpty ? res.message : 'Đăng ký thành công',
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: false,
          message: res.message.isNotEmpty ? res.message : 'Đăng ký thất bại',
        ));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(
        isLoading: false,
        message: 'Đăng ký thất bại',
      ));
    }
  }

}
