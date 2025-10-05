// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
//
// part 'home_state.dart';
//
// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(const HomeState());
//
//   void changeTab(int index) {
//     if (state.currentIndex == index) {
//       // Double tap - emit scroll to top event
//       emit(state.copyWith(
//         shouldScrollToTop: true,
//         scrollTargetIndex: index,
//       ));
//       // Reset scroll flag
//       emit(state.copyWith(shouldScrollToTop: false));
//     } else {
//       emit(state.copyWith(currentIndex: index));
//     }
//   }
//
//   void setKeyboardVisibility(bool isVisible) {
//     if (state.isKeyboardVisible != isVisible) {
//       emit(state.copyWith(isKeyboardVisible: isVisible));
//     }
//   }
//
//   void openPostSheet() {
//     emit(state.copyWith(shouldShowPostSheet: true));
//     emit(state.copyWith(shouldShowPostSheet: false));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void openPostSheet() {
    emit(state.copyWith(shouldShowPostSheet: true));
    emit(state.copyWith(shouldShowPostSheet: false));
  }
}