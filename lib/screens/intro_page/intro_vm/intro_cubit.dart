import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';
import 'package:meko_project/routers/app_router_paths.dart';

import 'intro_state.dart';

class IntroCubit extends Cubit<IntroState> {
  IntroCubit()
      : super(IntroState(
    currentIndex: 0,
    pageController: PageController(),
  ));

  void onPageChanged(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void backTap() {
    if (state.currentIndex > 0) {
      final newIndex = state.currentIndex - 1;
      emit(state.copyWith(currentIndex: newIndex));
      state.pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      );
    }
  }

  void nextTap(BuildContext context) {
    if (state.currentIndex < 2) {
      final newIndex = state.currentIndex + 1;
      emit(state.copyWith(currentIndex: newIndex));
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceInOut,
      );
    } else {
      SharedPref.instance.setBool(AppConsts.keyIntro, true);
      Navigator.pushReplacementNamed(context, RouterPaths.homePage);
    }
  }

  String getTitleBtn() {
    if (state.currentIndex == 0) {
      return 'Start';
    } else if (state.currentIndex == 1) {
      return 'Next';
    } else {
      return 'Finish';
    }
  }

  @override
  Future<void> close() {
    state.pageController.dispose();
    return super.close();
  }
}