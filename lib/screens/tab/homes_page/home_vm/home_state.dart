// part of 'home_cubit.dart';
//
// class HomeState extends Equatable {
//   final int currentIndex;
//   final bool isKeyboardVisible;
//   final bool shouldScrollToTop;
//   final int scrollTargetIndex;
//   final bool shouldShowPostSheet;
//
//   const HomeState({
//     this.currentIndex = 0,
//     this.isKeyboardVisible = false,
//     this.shouldScrollToTop = false,
//     this.scrollTargetIndex = -1,
//     this.shouldShowPostSheet = false,
//   });
//
//   HomeState copyWith({
//     int? currentIndex,
//     bool? isKeyboardVisible,
//     bool? shouldScrollToTop,
//     int? scrollTargetIndex,
//     bool? shouldShowPostSheet,
//   }) {
//     return HomeState(
//       currentIndex: currentIndex ?? this.currentIndex,
//       isKeyboardVisible: isKeyboardVisible ?? this.isKeyboardVisible,
//       shouldScrollToTop: shouldScrollToTop ?? this.shouldScrollToTop,
//       scrollTargetIndex: scrollTargetIndex ?? this.scrollTargetIndex,
//       shouldShowPostSheet: shouldShowPostSheet ?? this.shouldShowPostSheet,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     currentIndex,
//     isKeyboardVisible,
//     shouldScrollToTop,
//     scrollTargetIndex,
//     shouldShowPostSheet,
//   ];
// }

part of 'home_cubit.dart';

class HomeState extends Equatable {
  final bool shouldShowPostSheet;

  const HomeState({
    this.shouldShowPostSheet = false,
  });

  HomeState copyWith({
    bool? shouldShowPostSheet,
  }) {
    return HomeState(
      shouldShowPostSheet: shouldShowPostSheet ?? this.shouldShowPostSheet,
    );
  }

  @override
  List<Object?> get props => [shouldShowPostSheet];
}