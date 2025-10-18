import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_pass_state.dart';

typedef SendResetEmail = Future<void> Function(String email);
typedef VerifyOtpFn = Future<void> Function(String email, String otp);

Future<void> noopSendResetEmail(String email) async {}
Future<void> noopVerifyOtpFn(String email, String otp) async {}

class ForgotPassCubit extends Cubit<ForgotPassState> {
  ForgotPassCubit({
    required this.sendResetEmail,
    required this.verifyOtpFn,
  }) : super(ForgotPassState.initial());

  final SendResetEmail sendResetEmail;
  final VerifyOtpFn verifyOtpFn;

  factory ForgotPassCubit.forRequest({required SendResetEmail sendResetEmail}) {
    return ForgotPassCubit(sendResetEmail: sendResetEmail, verifyOtpFn: noopVerifyOtpFn);
  }

  factory ForgotPassCubit.forVerify({required VerifyOtpFn verifyOtpFn, String? initialEmail}) {
    final c = ForgotPassCubit(sendResetEmail: noopSendResetEmail, verifyOtpFn: verifyOtpFn);
    if (initialEmail != null && initialEmail.isNotEmpty) {
      c.onEmailChanged(initialEmail);
    }
    return c;
  }

  void onEmailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void onOtpChanged(String value) {
    emit(state.copyWith(otp: value.replaceAll(' ', ''), errorMessage: null));
  }

  Future<void> submit() async {
    if (state.loading) { return; }
    final email = state.email.trim();
    if (email.isEmpty) {
      emit(state.copyWith(errorMessage: 'Vui lòng nhập email'));
      return;
    }
    emit(state.copyWith(loading: true, errorMessage: null, sent: false));
    try {
      await sendResetEmail(email);
      emit(state.copyWith(loading: false, sent: true));
    } catch (_) {
      emit(state.copyWith(loading: false, errorMessage: 'Gửi email thất bại'));
    }
  }

  Future<void> verify() async {
    if (state.loading) { return; }
    final email = state.email.trim();
    final otp = state.otp.trim();
    if (email.isEmpty) {
      emit(state.copyWith(errorMessage: 'Thiếu email'));
      return;
    }
    if (otp.length != 6) {
      emit(state.copyWith(errorMessage: 'OTP phải gồm 6 số'));
      return;
    }
    emit(state.copyWith(loading: true, errorMessage: null, verified: false));
    try {
      await verifyOtpFn(email, otp);
      emit(state.copyWith(loading: false, verified: true));
    } catch (_) {
      emit(state.copyWith(loading: false, errorMessage: 'Xác thực OTP thất bại'));
    }
  }

  void reset() {
    emit(ForgotPassState.initial());
  }
}
