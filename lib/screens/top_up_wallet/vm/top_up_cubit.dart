import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';
import 'package:meko_project/repository/user/user_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';

part 'top_up_state.dart';

class TopUpCubit extends Cubit<TopUpState> {
  final UserRepo userRepo;
  final PaymentRepo paymentRepo;
  TopUpCubit({required this.userRepo, required this.paymentRepo}) : super(const TopUpState());

  Future<void> init() async {
    await fetchProfile();
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(isLoading: true));
    try {
      final res = await userRepo.getUserProfile();
      if (res != null) {
        emit(state.copyWith(isLoading: false, user: res.data as UserModel?));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectAmount(double amount) {
    emit(state.copyWith(selectedAmount: amount));
  }

  Future<void> createPin({required String pin, required String confirm}) async {
    if (pin.length != 6 || pin != confirm) {
      emit(state.copyWith(error: 'PIN không hợp lệ hoặc không trùng khớp'));
      emit(state.copyWith(error: null));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final result = await userRepo.createPinWallet(pin: pin, userId: state.user?.id ?? 0);
      if (result) {
        emit(state.copyWith(user: state.user?.copyWith(pinWallet: pin)));
      }
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  Future<void> topUp({required double amount, required BuildContext context}) async {
    if (amount <= 0) {
      emit(state.copyWith(error: 'Số tiền không hợp lệ'));
      emit(state.copyWith(error: null));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final result = await paymentRepo.createPayment(amount: amount, userId: state.user?.id ?? 0);
      if (result != null) {
        emit(state.copyWith(isSubmitting: false));
        Navigator.of(context).pushNamedAndRemoveUntil(AppRouterPaths.webviewPage, (route) => true, arguments: {'url': result, 'title': 'Thanh toán'});
      }
    } finally {
      emit(state.copyWith(isSubmitting: false));
    }
  }
}
