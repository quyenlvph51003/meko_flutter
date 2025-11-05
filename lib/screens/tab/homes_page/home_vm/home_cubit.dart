import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void openPostSheet() {
    emit(state.copyWith(shouldShowPostSheet: true));
    emit(state.copyWith(shouldShowPostSheet: false));
  }

  Future<void> isCheckLogin() async {
    final user = await SqliteHelper.getUserSql();
    if (user != null) {
      emit(state.copyWith(isLoggedIn: true));
    }
  }

  void changeTab(int index) async {
    final user = await SqliteHelper.getUserSql();
    if (user != null && index != 0 && index != 3) {
      emit(
        state.copyWith(
          currentIndex: index,
          isLoggedIn: true,
          uiRev: state.uiRev + 1,
          isCheckShowAuth: false,
        ),
      );
    } else {
      //chỉ chuyển tab nếu là 0 hoặc 3
      if (index == 0 || index == 3) {
        emit(
          state.copyWith(
            currentIndex: index,
            isLoggedIn: false,
            uiRev: state.uiRev + 1,
            isCheckShowAuth: false,
          ),
        );
      } else {
        // Giữ nguyên tab cũ, không cho chuyển
        emit(
          state.copyWith(
            isLoggedIn: false,
            uiRev: state.uiRev + 1,
            isCheckShowAuth: true,
          ),
        );
      }
    }
  }

  void refreshHome() {
    emit(state.copyWith(uiRev: state.uiRev + 1));
  }
}
