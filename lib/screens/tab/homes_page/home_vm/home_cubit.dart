import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void openPostSheet() {
    emit(state.copyWith(shouldShowPostSheet: true));
    emit(state.copyWith(shouldShowPostSheet: false));
  }

  Future<void> isCheckLogin() async {
    final logged = await SharedPref.instance.getBool(AppConsts.keyLoginSuccess) ?? false;
    emit(state.copyWith(isLoggedIn: logged));
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
