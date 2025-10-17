import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_consts.dart';
import 'package:meko_project/global_data/data_local/shared_pref.dart';

class IntroState {
  int currentIndex;
  PageController pageController;

  IntroState({required this.currentIndex, required this.pageController});

  IntroState copyWith({int? currentIndex}) {
    return IntroState(
      currentIndex: currentIndex ?? this.currentIndex,
      pageController: pageController,
    );
  }
}
