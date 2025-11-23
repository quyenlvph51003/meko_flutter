import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';

part 'purcharse_create_post_state.dart';

class PurcharseCreatePostCubit extends Cubit<PurcharseCreatePostState> {
  final PaymentRepo paymentRepo;
  PurcharseCreatePostCubit({required this.paymentRepo}) : super(const PurcharseCreatePostState());

  Future<void> initCubit() async {
    emit(state.copyWith(isLoading: true));
    await fetchUserPayments();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> fetchUserPayments() async {
    try {
      final result = await paymentRepo.getUserPayments();
      if (result?.data != null) {
        emit(state.copyWith(userPayments: result?.data));
      }
    } catch (error) {
      print('Lỗi call payment repo ${error.toString()}');
    }
  }
}
