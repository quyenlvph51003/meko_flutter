import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/screens/tab/tab_profile/tab_profile_vm/tab_profile_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountState.initial());

  void animateHeader() {
    emit(state.copyWith(headerReady: true));
  }

  void retryConnection() {
    emit(state.copyWith(retrying: true));
    Future.delayed(const Duration(milliseconds: 900)).then((_) {
      emit(state.copyWith(retrying: false));
    });
  }
}
